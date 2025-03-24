# Import the necessary libraries
import os
import gymnasium as gym
import numpy as np
import matplotlib.pyplot as plt
from tqdm import tqdm
from stable_baselines3.common.env_util import make_vec_env
from stable_baselines3.common.vec_env import DummyVecEnv, SubprocVecEnv, VecMonitor
from stable_baselines3.common.callbacks import CheckpointCallback, EvalCallback
from stable_baselines3.common.evaluation import evaluate_policy
import highway_env  # noqa: F401

# Import RecurrentPPO from sb3_contrib
try:
    from sb3_contrib import RecurrentPPO
except ImportError:
    # Install sb3_contrib if not already installed
    !pip install sb3_contrib
    from sb3_contrib import RecurrentPPO

# Create logs directory
os.makedirs("highway/recurrent_ppo_logs", exist_ok=True)

# Set up the environment
def setup_env(env_id="highway-fast-v0", num_envs=4):
    """
    Create and configure multiple environments for training.
    
    Args:
        env_id: The ID of the environment to create
        num_envs: Number of parallel environments to create
    
    Returns:
        A vectorized environment
    """
    # Make multiple environments for parallel training
    env = make_vec_env(
        env_id, 
        n_envs=num_envs,
        vec_env_cls=SubprocVecEnv,  # Use SubprocVecEnv for better performance with multiple environments
        monitor_dir="./highway/monitor_logs"
    )
    
    # Wrap with VecMonitor for additional statistics
    env = VecMonitor(env, filename="./highway/monitor_logs/recurrent_ppo")
    
    return env

# Explore the environment
def explore_environment(env_id="highway-fast-v0"):
    """
    Explore the action and observation space of the environment.
    
    Args:
        env_id: The ID of the environment to explore
    """
    # Create a single environment to inspect
    env = gym.make(env_id)
    
    print("\n===== Environment Information =====")
    print(f"Action Space: {env.action_space}")
    print(f"Action Space Shape: {env.action_space.shape}")
    print(f"Action Space Sample: {env.action_space.sample()}")
    print(f"\nObservation Space: {env.observation_space}")
    print(f"Observation Space Shape: {env.observation_space.shape}")
    
    # Get a sample observation
    obs, _ = env.reset()
    print(f"\nSample observation shape: {obs.shape}")
    
    # Close the environment
    env.close()
    
    return None

# Define a custom callback to log training metrics
class CustomCallback(EvalCallback):
    """
    Custom callback for logging and evaluation during training.
    """
    def __init__(self, eval_env, eval_freq=10000, log_path="./highway/recurrent_ppo_logs", **kwargs):
        super(CustomCallback, self).__init__(eval_env=eval_env, eval_freq=eval_freq, **kwargs)
        self.eval_freq = eval_freq
        self.log_path = log_path
        self.rewards = []
        self.timestamps = []
        
    def _on_step(self):
        result = super()._on_step()
        
        # Log rewards
        if self.num_timesteps % self.eval_freq == 0:
            # Get the last mean reward
            if len(self.evaluations_returns) > 0:
                mean_reward = self.evaluations_returns[-1]
                self.rewards.append(mean_reward)
                self.timestamps.append(self.num_timesteps)
                
                # Plot and save the learning curve
                plt.figure(figsize=(10, 6))
                plt.plot(self.timestamps, self.rewards)
                plt.xlabel('Timesteps')
                plt.ylabel('Mean Reward')
                plt.title('Learning Curve for Recurrent PPO')
                plt.savefig(f'{self.log_path}/learning_curve.png')
                plt.close()
        
        return result

# Configure and train a Recurrent PPO model
def train_recurrent_ppo(env, total_timesteps=500000, log_dir="./highway/recurrent_ppo_logs"):
    """
    Train a Recurrent PPO model on the given environment.
    
    Args:
        env: The training environment
        total_timesteps: Number of timesteps to train for
        log_dir: Directory to save logs and model checkpoints
    
    Returns:
        The trained model
    """
    # Create the evaluation environment (different from training env)
    eval_env = make_vec_env("highway-fast-v0", n_envs=1)
    
    # Set up the callbacks
    checkpoint_callback = CheckpointCallback(
        save_freq=50000,  # Save every 50k steps
        save_path=log_dir,
        name_prefix="recurrent_ppo_model",
        save_replay_buffer=True,
        save_vecnormalize=True
    )
    
    eval_callback = CustomCallback(
        eval_env=eval_env,
        eval_freq=10000,  # Evaluate every 10k steps
        log_path=log_dir,
        best_model_save_path=log_dir,
        deterministic=True,
        render=False
    )
    
    # Configure the Recurrent PPO model with improved hyperparameters
    model = RecurrentPPO(
        "MlpLstmPolicy",  # Use LSTM-based policy
        env,
        verbose=1,
        tensorboard_log=f"{log_dir}/tensorboard/",
        learning_rate=5e-4,
        n_steps=1024,  # Increased buffer size for better learning
        batch_size=64,
        n_epochs=10,  # More epochs for better convergence
        gamma=0.99,  # Discount factor
        gae_lambda=0.95,  # GAE lambda parameter
        clip_range=0.2,
        clip_range_vf=0.2,
        ent_coef=0.01,  # Entropy coefficient for exploration
        vf_coef=0.5,  # Value function coefficient
        max_grad_norm=0.5
    )
    
    # Train the model
    print("Starting training of Recurrent PPO...")
    model.learn(
        total_timesteps=total_timesteps,
        callback=[checkpoint_callback, eval_callback],
        tb_log_name="recurrent_ppo_run"
    )
    
    # Save the final model
    final_model_path = f"{log_dir}/final_model"
    model.save(final_model_path)
    print(f"Model saved to {final_model_path}")
    
    return model

# Evaluate the trained model
def evaluate_trained_model(model, env_id="highway-fast-v0", num_episodes=30):
    """
    Evaluate a trained model on multiple episodes.
    
    Args:
        model: The trained model to evaluate
        env_id: The environment to evaluate on
        num_episodes: Number of episodes to evaluate on
    
    Returns:
        Mean reward and mean episode length
    """
    # Create a deterministic evaluation environment
    eval_env = make_vec_env(env_id, n_envs=1)
    
    # Run evaluation with progress bar
    episode_rewards = []
    episode_lengths = []
    
    print(f"Evaluating model on {num_episodes} episodes...")
    for _ in tqdm(range(num_episodes)):
        obs = eval_env.reset()
        done = False
        total_reward = 0
        episode_length = 0
        
        while not done:
            action, _ = model.predict(obs, deterministic=True)
            obs, reward, terminated, truncated, info = eval_env.step(action)
            
            # Check if episode is done
            done = terminated[0] or truncated[0]
            total_reward += reward[0]
            episode_length += 1
        
        episode_rewards.append(total_reward)
        episode_lengths.append(episode_length)
    
    # Calculate mean and standard deviation
    mean_reward = np.mean(episode_rewards)
    std_reward = np.std(episode_rewards)
    mean_length = np.mean(episode_lengths)
    std_length = np.std(episode_lengths)
    
    # Print results
    print(f"\n{'-'*50}")
    print("Evaluation Results:")
    print(f"- Mean Reward: {mean_reward:.3f} ± {std_reward:.2f}")
    print(f"- Mean Episode Length: {mean_length:.3f} ± {std_length:.2f}")
    print(f"{'-'*50}")
    
    return mean_reward, mean_length

# Run a full experiment with Recurrent PPO
def run_recurrent_ppo_experiment(total_timesteps=500000, num_envs=4):
    """
    Run a complete experiment with Recurrent PPO on the highway environment.
    
    Args:
        total_timesteps: Total timesteps for training
        num_envs: Number of environments for parallel training
    """
    # Explore the environment
    explore_environment("highway-fast-v0")
    
    # Setup the environment
    env = setup_env("highway-fast-v0", num_envs=num_envs)
    
    # Train the model
    model = train_recurrent_ppo(env, total_timesteps=total_timesteps)
    
    # Evaluate the trained model
    mean_reward, mean_length = evaluate_trained_model(model, "highway-fast-v0")
    
    # Generate video of the trained model
    record_video("highway-fast-v0", model, video_length=100, prefix="recurrent-ppo-agent", fps=5)
    show_videos("videos", prefix="recurrent-ppo-agent")
    
    return model, mean_reward, mean_length

# Compare with a non-recurrent PPO model
def compare_with_standard_ppo(recurrent_model, total_timesteps=300000):
    """
    Train and compare a standard PPO model with the recurrent version.
    
    Args:
        recurrent_model: The trained recurrent model for comparison
        total_timesteps: Timesteps to train the standard model
    """
    from stable_baselines3 import PPO
    
    # Setup environment for standard PPO
    env = make_vec_env("highway-fast-v0", n_envs=4)
    
    # Configure standard PPO
    standard_model = PPO(
        "MlpPolicy",  # Standard MLP policy (no recurrence)
        env,
        verbose=1,
        tensorboard_log="./highway/standard_ppo_logs/tensorboard/",
        learning_rate=5e-4,
        n_steps=1024,
        batch_size=64,
        n_epochs=10,
        gamma=0.99,
        gae_lambda=0.95,
        clip_range=0.2,
        clip_range_vf=0.2,
        ent_coef=0.01,
        vf_coef=0.5,
        max_grad_norm=0.5
    )
    
    # Train the standard model
    print("Training standard PPO for comparison...")
    standard_model.learn(
        total_timesteps=total_timesteps,
        tb_log_name="standard_ppo_run"
    )
    
    # Save the standard model
    standard_model.save("./highway/standard_ppo_model")
    
    # Evaluate both models
    print("\nEvaluating Recurrent PPO:")
    recurrent_reward, recurrent_length = evaluate_trained_model(recurrent_model)
    
    print("\nEvaluating Standard PPO:")
    standard_reward, standard_length = evaluate_trained_model(standard_model)
    
    # Compare results
    print("\n===== Model Comparison =====")
    print(f"Recurrent PPO Mean Reward: {recurrent_reward:.3f}")
    print(f"Standard PPO Mean Reward: {standard_reward:.3f}")
    print(f"Difference: {recurrent_reward - standard_reward:.3f}")
    print(f"Percentage Improvement: {((recurrent_reward - standard_reward) / abs(standard_reward)) * 100:.2f}%")
    
    # Generate comparison video
    record_video("highway-fast-v0", standard_model, video_length=100, prefix="standard-ppo-agent", fps=5)
    show_videos("videos", prefix="standard-ppo-agent")
    
    return standard_model

# Main execution
if __name__ == "__main__":
    # Run the full experiment
    recurrent_model, mean_reward, mean_length = run_recurrent_ppo_experiment(
        total_timesteps=300000,  # Adjust based on available time
        num_envs=4
    )
    
    # Compare with standard PPO (if time permits)
    standard_model = compare_with_standard_ppo(recurrent_model, total_timesteps=300000)
    
    # Save models for later use
    recurrent_model.save("highway_final_recurrent")
    standard_model.save("highway_final_standard")
    
    print("\nExperiment complete!")
