Sub ExtraireTitresFichiers()
    ' Déclaration des variables
    Dim chemin As String
    Dim fso As Object
    Dim dossier As Object
    Dim fichier As Object
    Dim feuille As Worksheet
    Dim ligne As Integer
    
    ' Initialisation
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Utiliser le répertoire spécifié directement
    chemin = "C:\Users\m.oniaefuto\Documents\ALL WSP FILES"
    
    ' Vérifier si le dossier existe
    If Not fso.FolderExists(chemin) Then
        MsgBox "Le dossier spécifié n'existe pas.", vbExclamation
        Exit Sub
    End If
    
    ' Créer une nouvelle feuille ou utiliser la feuille active
    On Error Resume Next
    Application.DisplayAlerts = False
    Worksheets("Titres des fichiers").Delete
    Application.DisplayAlerts = True
    Set feuille = Worksheets.Add
    feuille.Name = "Titres des fichiers"
    On Error GoTo 0
    
    ' Ajouter les en-têtes
    feuille.Cells(1, 1) = "Nom du fichier"
    feuille.Cells(1, 2) = "Extension"
    feuille.Cells(1, 3) = "Taille (octets)"
    feuille.Cells(1, 4) = "Date de modification"
    feuille.Cells(1, 5) = "Chemin complet"
    
    ' Mettre en forme les en-têtes
    feuille.Range("A1:E1").Font.Bold = True
    
    ' Initialiser le compteur de ligne
    ligne = 2
    
    ' Accéder au dossier
    Set dossier = fso.GetFolder(chemin)
    
    ' Parcourir tous les fichiers du dossier
    For Each fichier In dossier.Files
        ' Écrire les informations dans la feuille
        feuille.Cells(ligne, 1) = fso.GetBaseName(fichier.Name)
        feuille.Cells(ligne, 2) = fso.GetExtensionName(fichier.Name)
        feuille.Cells(ligne, 3) = fichier.Size
        feuille.Cells(ligne, 4) = fichier.DateLastModified
        feuille.Cells(ligne, 5) = fichier.Path
        
        ' Incrémenter le compteur de ligne
        ligne = ligne + 1
    Next fichier
    
    ' Ajuster la largeur des colonnes automatiquement
    feuille.Columns("A:E").AutoFit
    
    ' Appliquer un filtre
    feuille.Range("A1:E1").AutoFilter
    
    ' Afficher un message de confirmation
    MsgBox "L'extraction est terminée. " & (ligne - 2) & " fichiers ont été trouvés dans le dossier " & chemin, vbInformation
    
    ' Libérer les objets
    Set fichier = Nothing
    Set dossier = Nothing
    Set fso = Nothing
End Sub

' Sous-procédure pour extraire les fichiers d'un dossier et ses sous-dossiers
Sub ExtraireTitresFichiersRecursif()
    ' Déclaration des variables
    Dim chemin As String
    Dim fso As Object
    Dim feuille As Worksheet
    Dim ligne As Integer
    
    ' Initialisation
    Set fso = CreateObject("Scripting.FileSystemObject")
    
    ' Utiliser le répertoire spécifié directement
    chemin = "C:\Users\m.oniaefuto\Documents\ALL WSP FILES"
    
    ' Vérifier si le dossier existe
    If Not fso.FolderExists(chemin) Then
        MsgBox "Le dossier spécifié n'existe pas.", vbExclamation
        Exit Sub
    End If
    
    ' Créer une nouvelle feuille ou utiliser la feuille active
    On Error Resume Next
    Application.DisplayAlerts = False
    Worksheets("Titres des fichiers").Delete
    Application.DisplayAlerts = True
    Set feuille = Worksheets.Add
    feuille.Name = "Titres des fichiers"
    On Error GoTo 0
    
    ' Ajouter les en-têtes
    feuille.Cells(1, 1) = "Nom du fichier"
    feuille.Cells(1, 2) = "Extension"
    feuille.Cells(1, 3) = "Taille (octets)"
    feuille.Cells(1, 4) = "Date de modification"
    feuille.Cells(1, 5) = "Dossier parent"
    feuille.Cells(1, 6) = "Chemin complet"
    
    ' Mettre en forme les en-têtes
    feuille.Range("A1:F1").Font.Bold = True
    
    ' Initialiser le compteur de ligne
    ligne = 2
    
    ' Lancer la recherche récursive
    ExplorerDossier chemin, fso, feuille, ligne
    
    ' Ajuster la largeur des colonnes automatiquement
    feuille.Columns("A:F").AutoFit
    
    ' Appliquer un filtre
    feuille.Range("A1:F1").AutoFilter
    
    ' Afficher un message de confirmation
    MsgBox "L'extraction est terminée. " & (ligne - 2) & " fichiers ont été trouvés dans le dossier " & chemin & " et ses sous-dossiers.", vbInformation
    
    ' Libérer les objets
    Set fso = Nothing
End Sub

' Procédure pour explorer récursivement un dossier et ses sous-dossiers
Private Sub ExplorerDossier(chemin As String, fso As Object, feuille As Worksheet, ByRef ligne As Integer)
    Dim dossier As Object
    Dim sousDossier As Object
    Dim fichier As Object
    
    ' Accéder au dossier
    Set dossier = fso.GetFolder(chemin)
    
    ' Parcourir tous les fichiers du dossier
    For Each fichier In dossier.Files
        ' Écrire les informations dans la feuille
        feuille.Cells(ligne, 1) = fso.GetBaseName(fichier.Name)
        feuille.Cells(ligne, 2) = fso.GetExtensionName(fichier.Name)
        feuille.Cells(ligne, 3) = fichier.Size
        feuille.Cells(ligne, 4) = fichier.DateLastModified
        feuille.Cells(ligne, 5) = dossier.Name
        feuille.Cells(ligne, 6) = fichier.Path
        
        ' Incrémenter le compteur de ligne
        ligne = ligne + 1
    Next fichier
    
    ' Explorer récursivement tous les sous-dossiers
    For Each sousDossier In dossier.SubFolders
        ExplorerDossier sousDossier.Path, fso, feuille, ligne
    Next sousDossier
    
    ' Libérer les objets
    Set fichier = Nothing
    Set sousDossier = Nothing
    Set dossier = Nothing
End Sub
