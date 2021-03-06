Set-ExecutionPolicy unrestricted
# Set-ExecutionPolicy unrestricted
# Set-ExecutionPolicy RemoteSigned

##Add-Type -AssemblyName System.Windows.Forms

#region Import the Assemblies
[reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
[reflection.assembly]::loadwithpartialname("System.Drawing") 
[reflection.assembly]::loadwithpartialname("System.IO") 
[reflection.assembly]::loadwithpartialname("System") 
#endregion

### metodo 1####################################
$My_Button_Click = 
{
    [System.Windows.Forms.MessageBox]::Show("Hello World." , "My Dialog Box")
}

######################
### Form Functions ###
######################
       function ValidateAllFields()
        {

           ########################### $invalidInput = $batchProcess.ValidateAllInputs()

            if ($invalidInput -eq 0)
            {
                return $true
            }
            
            #$message = "Content of Field " $invalidInput " is invalid."
            #MessageBox.Show(message, "Validation Fields", MessageBoxButtons.OK, MessageBoxIcon.Warning);

            #Ajust (Set Focus)
            switch ($invalidInput)
            {
                1 { $global:textBoxRootDir.Focus() }
                2 { $global:textBoxOutputFile.Focus() }
                default {$global:textBoxRootDir.Focus() }
            }

            return $false
        }

        function EnableControls($enable)
        {
           foreach ($control in $global:Form.Controls)
            {
              if (($control.GetType() -eq [System.Windows.Forms.Button]) -or ($control.GetType() -eq [System.Windows.Forms.TextBox]))
              {
                $control.Enabled = $enable
              }
            }

            $buttonCloseOrCancel.Enabled = true;

            if ($enable)
            {
                $global:buttonCloseOrCancel.Text = "Close"
                $global:buttonCloseOrCancel.Tag = $null
                $global:Form.Cursor = Cursors.Default
                $global:buttonCloseOrCancel.Cursor = [System.Windows.Forms.Cursors]::Default
                $global:progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
                $global:progressBar.Visible = $false
                $global:labelMessage.Text = ""
            }
            else
            {
                #//buttonCloseOrCancel.Text = "Cancel";
                $global:buttonCloseOrCancel.Tag = 1;
                $global:Form.Cursor = [System.Windows.Forms.Cursors]::WaitCursor;
                $global:buttonCloseOrCancel.Cursor = Cursors.AppStarting;
                $global:progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee;
                $global:progressBar.Visible = $true;
            }

        }

###################
### Form events ###
###################

function FormCucumberFeaturesExport_Load()
{
            Write-Output "Form is Load."
            
            $global:textBoxRootDir.Text = ""
            $global:textBoxOutputFile.Text = ""

            $global:labelMessage.Text = "";
            $global:progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Continuous
            $global:progressBar.Visible = $false
}

Function FormCucumberFeaturesExport_FormClosed()
{
    Write-Output "Form is Closed."
}

function buttonDialogRoot_Click()
{
    #$path = [System.Windows.Forms.Application]::ExecutablePath
    #$path = [System.Environment.SpecialFolder]::MyDocuments  --> error
    $path = [System.Environment]::GetFolderPath("MyDocuments")
    $dirName = [System.IO.Path]::GetDirectoryName($path)
    
    if ([String]::IsNullOrEmpty($global:textBoxRootDir.Text) -ne $true)
    {
        $dirName = [System.IO.Path]::GetDirectoryName($global:textBoxRootDir.Text)
    }

    $folderBrowserDialog = New-Object System.Windows.Forms.FolderBrowserDialog
    #folderBrowserDialog.RootFolder = Environment.SpecialFolder.MyComputer
    $folderBrowserDialog.SelectedPath = $dirName
    $folderBrowserDialog.ShowNewFolderButton = $true

    $result = $folderBrowserDialog.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $global:textBoxRootDir.Text = $folderBrowserDialog.SelectedPath
    }
    $global:textBoxRootDir.Focus()
}

function buttonDialogCSV_Click()
{
    #$path = [System.Windows.Forms.Application]::ExecutablePath
    $path = [System.Environment.SpecialFolder]::MyDocuments
    $dirName = [System.IO.Path]::GetDirectoryName($path)

    if ([String]::IsNullOrEmpty($global:textBoxRootDir.Text) -ne $true)
    {
        $dirName = [System.IO.Path]::GetDirectoryName($global:textBoxRootDir.Text)
    }

    $saveFileDialog1 = New-Object System.Windows.Forms.SaveFileDialog

    $saveFileDialog1.InitialDirectory = $dirName
    $saveFileDialog1.Title = "Save CSV File"
    $saveFileDialog1.CheckFileExists = $false
    $saveFileDialog1.CheckPathExists = $true
    $saveFileDialog1.DefaultExt = ".csv"
    $saveFileDialog1.Filter = "CSV files |(*.csv)"
    $saveFileDialog1.FilterIndex = 2
    $saveFileDialog1.RestoreDirectory = $true

    $result = $saveFileDialog1.ShowDialog()
    if ($result -eq [System.Windows.Forms.DialogResult]::OK)
    {
        $global:textBoxOutputFile.Text = $saveFileDialog1.FileName
    }
    
    $global:textBoxOutputFile.Focus()
}

function buttonGenerate_Click()
{
    #[System.Windows.Forms.MessageBox]::Show("Hello World222." , "My Dialog Box")
    
            $global:progressBar.MarqueeAnimationSpeed = 10
            $global:progressBar.Minimum = 0
            $global:progressBar.Maximum = 100
            $global:progressBar.MarqueeAnimationSpeed = 10
            $global:progressBar.Value = 0

            if (($global:textBoxOutputFile.Text.Length -gt 0) -and (-not ($global:textBoxOutputFile.Text.ToLower().EndsWith(".csv"))))
            {
                $global:textBoxOutputFile.Text += ".csv";
            }
            
            if ($batchProcess -eq $null)
            {
            #    $batchProcess = New-Object BatchProcess.GenerateExport($textBoxRootDir.Text, $textBoxOutputFile.Text, $false);
            
            }
            
            #if (-not ValidateAllFields())
            if (ValidateAllFields -eq $false)
            {
                return;
            }
            
            EnableControls($false)
                        
           #$batchProcess.Start();
           ##$batchProcess.Start(_handlerBatchMessage)

            EnableControls($true)

            if ($checkBoxRunAtEnd.Checked -eq $true)
            {
                try
                {
                   # System.Diagnostics.Process.Start($textBoxOutputFile.Text);
                Start-Process -FilePath $textBoxOutputFile.Text
                }
                catch
                {
                    $ErrorMessage = $_.Exception.Message
                    $FailedItem = $_.Exception.ItemName
                    #Send-MailMessage -From ExpensesBot@MyCompany.Com -To WinAdmin@MyCompany.Com -Subject "HR File Read Failed!" -SmtpServer EXCH01.AD.MyCompany.Com -Body "We failed to read file $FailedItem. The error message was $ErrorMessage"
                    Break
                }
            }

            $Form.Activate();
           
            [System.Windows.Forms.MessageBox]::Show("Process completed.", "Batch Process", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information);
}

Function buttonCloseOrCancel_Click()
{
    #[System.Windows.Forms.MessageBox]::Show("Hello World222." , "My Dialog Box")
    if ($global:buttonCloseOrCancel.Tag -eq $null)
    {
        $global:Form.Close()
    }
}

##################
### Form mount ###
##################
Function CreateGlobalVariables()
{
    $global:Form = $null

    $global:progressBar = $null
    $global:label1 = $null
    $global:textBoxRootDir = $null
    $global:buttonDialogRoot = $null
    $global:label2 = $null
    $global:textBoxOutputFile = $null
    $global:buttonDialogCSV = $null
    $global:checkBoxRunAtEnd = $null
    $global:labelMessage = $null
    $global:labelNote = $null
    $global:buttonGenerate = $null
    $global:buttonCloseOrCancel = $null
    
    $global:batchProcess = $null
}

Function MountForm()
{
    #Create controls
    $global:Form = New-Object system.Windows.Forms.Form

    $global:progressBar = New-Object System.Windows.Forms.ProgressBar 
    $global:label1 = New-Object System.Windows.Forms.Label 
    $global:textBoxRootDir = New-Object System.Windows.Forms.TextBox 
    $global:buttonDialogRoot = New-Object System.Windows.Forms.Button 
    $global:label2 = New-Object System.Windows.Forms.Label 
    $global:textBoxOutputFile = New-Object System.Windows.Forms.TextBox 
    $global:buttonDialogCSV = New-Object System.Windows.Forms.Button 
    $global:checkBoxRunAtEnd = New-Object System.Windows.Forms.CheckBox 
    $global:labelMessage = New-Object System.Windows.Forms.Label 
    $global:labelNote = New-Object System.Windows.Forms.Label 
    $global:buttonGenerate = New-Object System.Windows.Forms.Button 
    $global:buttonCloseOrCancel = New-Object System.Windows.Forms.Button 

    # 
    # progressBar
    # 
    $global:progressBar.Dock = [System.Windows.Forms.DockStyle]::Top
    $global:progressBar.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:progressBar.Location = New-Object System.Drawing.Point(0, 0)
    $global:progressBar.MarqueeAnimationSpeed = 10
    $global:progressBar.Name = "progressBar"
    $global:progressBar.Size = New-Object System.Drawing.Size(584, 13)
    $global:progressBar.TabIndex = 73
            
    # 
    # label1
    # 
    $global:label1.Name = "label1"
    $global:label1.AutoSize = $true
    $global:label1.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:label1.Location = New-Object System.Drawing.Point(12, 34)
    $global:label1.Size = New-Object System.Drawing.Size(77, 13)
    $global:label1.TabIndex = 68
    $global:label1.Text = "Features Root:"

    # 
    # textBoxRootDir
    # 
    $global:textBoxRootDir.Location = New-Object System.Drawing.Point(115, 31)
    $global:textBoxRootDir.Name = "textBoxRootDir"
    $global:textBoxRootDir.Size = New-Object System.Drawing.Size(428, 20)
    $global:textBoxRootDir.TabIndex = 64;
    $global:textBoxRootDir.Text = "\\nas-qnap\\projects\DOT.NET\CucumberFeaturesToCSV (public)\CucumberFeaturesToCSV\features" 
 
    # 
    # buttonDialogRoot
    # 
    $global:buttonDialogRoot.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:buttonDialogRoot.Location = New-Object System.Drawing.Point(549, 31)
    $global:buttonDialogRoot.Name = "buttonDialogRoot"
    $global:buttonDialogRoot.Size = New-Object System.Drawing.Size(24, 20)
    $global:buttonDialogRoot.TabIndex = 66
    $global:buttonDialogRoot.Text = "..."
    $global:buttonDialogRoot.UseVisualStyleBackColor = $global:true
    #$global:buttonDialogRoot.Click += new System.EventHandler(this.buttonDialogRoot_Click);
    $global:buttonDialogRoot.Add_Click( {buttonDialogRoot_Click} )       

    ##################################

    #
    #label2
    #
    $global:label2.AutoSize = $global:true
    $global:label2.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:label2.Location =  New-Object System.Drawing.Point(11, 61)
    $global:label2.Name = "label2"
    $global:label2.Size =  New-Object System.Drawing.Size(91, 13)
    $global:label2.TabIndex = 69
    $global:label2.Text = "Output File (CSV):"
    
    #
    # textBoxOutputFile
    # 
    $global:textBoxOutputFile.Location = New-Object System.Drawing.Point(114, 58);
    $global:textBoxOutputFile.Name = "textBoxOutputFile";
    $global:textBoxOutputFile.Size = New-Object System.Drawing.Size(428, 20);
    $global:textBoxOutputFile.TabIndex = 65;
    $global:textBoxOutputFile.Text = "test.csv";
            
    #
    # buttonDialogCSV
    # 
    $global:buttonDialogCSV.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:buttonDialogCSV.Location = New-Object System.Drawing.Point(548, 57)
    $global:buttonDialogCSV.Name = "buttonDialogCSV"
    $global:buttonDialogCSV.Size = New-Object System.Drawing.Size(24, 20)
    $global:buttonDialogCSV.TabIndex = 67
    $global:buttonDialogCSV.Text = "..."
    $global:buttonDialogCSV.UseVisualStyleBackColor = $global:true
    #$global:buttonDialogCSV.Click += new System.EventHandler(this.buttonDialogCSV_Click);
    $global:buttonDialogCSV.Add_Click( {buttonDialogCSV_Click} )   
        
    ###################################
            
    # 
    # checkBoxRunAtEnd
    # 
    $global:checkBoxRunAtEnd.AutoSize = $global:true
    $global:checkBoxRunAtEnd.Checked = $global:true
    $global:checkBoxRunAtEnd.CheckState = [System.Windows.Forms.CheckState]::Checked
    $global:checkBoxRunAtEnd.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:checkBoxRunAtEnd.Location =  New-Object System.Drawing.Point(15, 91)
    $global:checkBoxRunAtEnd.Name = "checkBoxRunAtEnd"
    $global:checkBoxRunAtEnd.Size =  New-Object System.Drawing.Size(205, 17)
    $global:checkBoxRunAtEnd.TabIndex = 74
    $global:checkBoxRunAtEnd.Text = "Open result file  after process finished."
    $global:checkBoxRunAtEnd.UseVisualStyleBackColor = $global:true
    
    #
    # labelMessage
    # 
    $global:labelMessage.AutoSize = $global:true;
    $global:labelMessage.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:labelMessage.Location =  New-Object  System.Drawing.Point(12, 202)
    $global:labelMessage.Name = "labelMessage"
    $global:labelMessage.Size =  New-Object  System.Drawing.Size(50, 13)
    $global:labelMessage.TabIndex = 71
    $global:labelMessage.Text = "Message"
            
            
    # 
    # labelNote
    # 
    $global:labelNote.AutoSize = $global:true
    $global:labelNote.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:labelNote.Location =  New-Object  System.Drawing.Point(341, 160)
    $global:labelNote.Name = "labelNote"
    $global:labelNote.Size =  New-Object  System.Drawing.Size(218, 13)
    $global:labelNote.TabIndex = 75
    $global:labelNote.Text = "Note: All char semicolon are replaced by <$global:>"     
            
    ################################################
            
    #
    # buttonGenerate
    # 
    $global:buttonGenerate.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:buttonGenerate.Location = New-Object System.Drawing.Point(344, 192)
    $global:buttonGenerate.Name = "buttonGenerate"
    $global:buttonGenerate.Size = New-Object System.Drawing.Size(105, 24)
    $global:buttonGenerate.TabIndex = 70
    $global:buttonGenerate.Text = "Generate"
    $global:buttonGenerate.UseVisualStyleBackColor = $global:true
    #$global:buttonGenerate.Click += new System.EventHandler(this.buttonGenerate_Click)
    $global:buttonGenerate.Add_Click({buttonGenerate_Click})
        
    # 
    # buttonCloseOrCancel
    # 
    $global:buttonCloseOrCancel.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
    $global:buttonCloseOrCancel.Location = New-Object System.Drawing.Point(464, 192)
    $global:buttonCloseOrCancel.Name = "buttonCloseOrCancel"
    $global:buttonCloseOrCancel.Size = New-Object System.Drawing.Size(105, 24)
    $global:buttonCloseOrCancel.TabIndex = 72
    $global:buttonCloseOrCancel.Text = "Close"
    $global:buttonCloseOrCancel.UseVisualStyleBackColor = $global:true
    #$global:buttonCloseOrCancel.Click += new System.EventHandler(this.buttonCloseOrCancel_Click);
    $global:buttonCloseOrCancel.Add_Click({buttonCloseOrCancel_Click})
    
    ##########################################################            
            
    # 
    # Form
    # 
    $global:Form.AutoScaleDimensions = New-Object System.Drawing.SizeF(6, 13)
    $global:Form.ClientSize = New-Object System.Drawing.Size(584, 230)
    $global:Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle #enum
    #$global:Form.Icon = ((System.Drawing.Icon)(resources.GetObject("$global:this.Icon")))
    $global:Form.MaximizeBox = $global:false
    $global:Form.Name = "FormCucumberFeaturesExport"
    $global:Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen #enum
    $global:Form.Text = "Cucumber - Export features to CSV file"
    $global:Form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font #enum
    $global:Form.Cursor = [System.Windows.Forms.Cursors]::Default #enum

    # 
    # Add Controls to Form
    # 
    $global:Form.Controls.Add($global:progressBar)

    $global:Form.Controls.Add($global:label1)
    $global:Form.Controls.Add($global:textBoxRootDir)
    $global:Form.Controls.Add($global:buttonDialogRoot)

    $global:Form.Controls.Add($global:label2)
    $global:Form.Controls.Add($global:textBoxOutputFile)
    $global:Form.Controls.Add($global:buttonDialogCSV)
            
    $global:Form.Controls.Add($global:checkBoxRunAtEnd)
    $global:Form.Controls.Add($global:labelMessage)
    $global:Form.Controls.Add($global:labelNote)
    $global:Form.Controls.Add($global:buttonGenerate)
    $global:Form.Controls.Add($global:buttonCloseOrCancel)
            
    #$global:Load += new System.EventHandler($global:FormCucumberFeaturesExport_Load)
    $global:Form.Add_Load({FormCucumberFeaturesExport_Load})            
    #$global:FormClosed += new System.Windows.Forms.FormClosedEventHandler($global:FormCucumberFeaturesExport_FormClosed)
    $global:Form.Add_Closed( {FormCucumberFeaturesExport_FormClosed} )
}

############
### MAIN ###
############

Write-Output "Start Pipeline."

CreateGlobalVariables
MountForm
$global:Form.ShowDialog()

Write-Output "Finished Pipeline."
$controles = $Form.Controls

           ForEach ($control in $controles)
           {
Write-Output $control.GetType().Name

$xpto =  $control.GetType()
if ($xpto -eq [System.Windows.Forms.Label])
{
Write-Output "SIM"
}
else
{
Write-Output "NAO"
}

           }
