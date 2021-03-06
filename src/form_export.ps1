Set-ExecutionPolicy unrestricted
# Set-ExecutionPolicy unrestricted
# Set-ExecutionPolicy RemoteSigned

##Add-Type -AssemblyName System.Windows.Forms

##region Import the Assemblies
#[reflection.assembly]::loadwithpartialname("System.Windows.Forms") 
#[reflection.assembly]::loadwithpartialname("System.Drawing") 
##endregion

### metodo 1####################################
$My_Button_Click = 
{
    [System.Windows.Forms.MessageBox]::Show("Hello World." , "My Dialog Box")
}
### metodo 2##########################################
Function My_Button2_Click()
{
    [System.Windows.Forms.MessageBox]::Show("Hello World222." , "My Dialog Box")
}


$Form = New-Object system.Windows.Forms.Form

$progressBar = New-Object System.Windows.Forms.ProgressBar 
$label1 = New-Object System.Windows.Forms.Label 
$textBoxRootDir = New-Object System.Windows.Forms.TextBox 
$buttonDialogRoot = New-Object System.Windows.Forms.Button 
$label2 = New-Object System.Windows.Forms.Label 
$textBoxOutputFile = New-Object System.Windows.Forms.TextBox 
$buttonDialogCSV = New-Object System.Windows.Forms.Button 
$checkBoxRunAtEnd = New-Object System.Windows.Forms.CheckBox 
$labelMessage = New-Object System.Windows.Forms.Label 
$labelNote = New-Object System.Windows.Forms.Label 
$buttonGenerate = New-Object System.Windows.Forms.Button 
$buttonCloseOrCancel = New-Object System.Windows.Forms.Button 

        # 
        # progressBar
        # 
            $progressBar.Dock = [System.Windows.Forms.DockStyle]::Top
            $progressBar.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $progressBar.Location = New-Object System.Drawing.Point(0, 0)
            $progressBar.MarqueeAnimationSpeed = 10
            $progressBar.Name = "progressBar"
            $progressBar.Size = New-Object System.Drawing.Size(584, 13);
            $progressBar.TabIndex = 73;
            
            # 
            # label1
            # 
            $label1.Name = "label1"
            $label1.AutoSize = $true
            $label1.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $label1.Location = New-Object System.Drawing.Point(12, 34)
            $label1.Size = New-Object System.Drawing.Size(77, 13)
            $label1.TabIndex = 68
            $label1.Text = "Features Root:"

           # 
           # textBoxRootDir
           # 
            $textBoxRootDir.Location = New-Object System.Drawing.Point(115, 31)
            $textBoxRootDir.Name = "textBoxRootDir"
            $textBoxRootDir.Size = New-Object  System.Drawing.Size(428, 20)
            $textBoxRootDir.TabIndex = 64;
            $textBoxRootDir.Text = "\\nas-qnap\\projects\DOT.NET\CucumberFeaturesToCSV (public)\CucumberFeaturesToCSV\features" 
                     
           # 
           # buttonDialogRoot
           # 
            $buttonDialogRoot.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $buttonDialogRoot.Location = New-Object System.Drawing.Point(549, 31);
            $buttonDialogRoot.Name = "buttonDialogRoot"
            $buttonDialogRoot.Size = New-Object System.Drawing.Size(24, 20)
            $buttonDialogRoot.TabIndex = 66
            $buttonDialogRoot.Text = "..."
            $buttonDialogRoot.UseVisualStyleBackColor = $true
            #$buttonDialogRoot.Click += new System.EventHandler(this.buttonDialogRoot_Click);
            
            
            ##################################
             #
            #label2
            #
            $label2.AutoSize = $true
            $label2.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $label2.Location =  New-Object System.Drawing.Point(11, 61)
            $label2.Name = "label2"
            $label2.Size =  New-Object System.Drawing.Size(91, 13)
            $label2.TabIndex = 69
            $label2.Text = "Output File (CSV):"
            
            #
            # textBoxOutputFile
            # 
            $textBoxOutputFile.Location = New-Object System.Drawing.Point(114, 58);
            $textBoxOutputFile.Name = "textBoxOutputFile";
            $textBoxOutputFile.Size = New-Object System.Drawing.Size(428, 20);
            $textBoxOutputFile.TabIndex = 65;
            $textBoxOutputFile.Text = "test.csv";
            
            #
            # buttonDialogCSV
            # 
            $buttonDialogCSV.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $buttonDialogCSV.Location = New-Object System.Drawing.Point(548, 57)
            $buttonDialogCSV.Name = "buttonDialogCSV"
            $buttonDialogCSV.Size = New-Object System.Drawing.Size(24, 20)
            $buttonDialogCSV.TabIndex = 67
            $buttonDialogCSV.Text = "..."
            $buttonDialogCSV.UseVisualStyleBackColor = $true
            #$buttonDialogCSV.Click += new System.EventHandler(this.buttonDialogCSV_Click);
            
            
            ###################################
            
            
            # 
            # checkBoxRunAtEnd
            # 
            $checkBoxRunAtEnd.AutoSize = $true
            $checkBoxRunAtEnd.Checked = $true
            $checkBoxRunAtEnd.CheckState = [System.Windows.Forms.CheckState]::Checked
            $checkBoxRunAtEnd.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $checkBoxRunAtEnd.Location =  New-Object System.Drawing.Point(15, 91)
            $checkBoxRunAtEnd.Name = "checkBoxRunAtEnd"
            $checkBoxRunAtEnd.Size =  New-Object System.Drawing.Size(205, 17)
            $checkBoxRunAtEnd.TabIndex = 74
            $checkBoxRunAtEnd.Text = "Open result file  after process finished."
            $checkBoxRunAtEnd.UseVisualStyleBackColor = $true
            
            #
            # labelMessage
            # 
            $labelMessage.AutoSize = $true;
            $labelMessage.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $labelMessage.Location =  New-Object  System.Drawing.Point(12, 202)
            $labelMessage.Name = "labelMessage"
            $labelMessage.Size =  New-Object  System.Drawing.Size(50, 13)
            $labelMessage.TabIndex = 71
            $labelMessage.Text = "Message"
            
            
            # 
            # labelNote
            # 
            $labelNote.AutoSize = $true
            $labelNote.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $labelNote.Location =  New-Object  System.Drawing.Point(341, 160)
            $labelNote.Name = "labelNote"
            $labelNote.Size =  New-Object  System.Drawing.Size(218, 13)
            $labelNote.TabIndex = 75
            $labelNote.Text = "Note: All char semicolon are replaced by <$>"     
            
            ################################################
            
            #
            # buttonGenerate
            # 
            $buttonGenerate.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $buttonGenerate.Location = New-Object System.Drawing.Point(344, 192)
            $buttonGenerate.Name = "buttonGenerate"
            $buttonGenerate.Size = New-Object System.Drawing.Size(105, 24)
            $buttonGenerate.TabIndex = 70
            $buttonGenerate.Text = "Generate"
            $buttonGenerate.UseVisualStyleBackColor = $true
            #$buttonGenerate.Click += new System.EventHandler(this.buttonGenerate_Click)
             $buttonGenerate.Add_Click($My_Button_Click)
            
            # 
            # buttonCloseOrCancel
            # 
            $buttonCloseOrCancel.ImeMode = [System.Windows.Forms.ImeMode]::NoControl
            $buttonCloseOrCancel.Location = New-Object System.Drawing.Point(464, 192)
            $buttonCloseOrCancel.Name = "buttonCloseOrCancel"
            $buttonCloseOrCancel.Size = New-Object System.Drawing.Size(105, 24)
            $buttonCloseOrCancel.TabIndex = 72
            $buttonCloseOrCancel.Text = "Close"
            $buttonCloseOrCancel.UseVisualStyleBackColor = $true
            #$buttonCloseOrCancel.Click += new System.EventHandler(this.buttonCloseOrCancel_Click);
            $buttonCloseOrCancel.Add_Click({My_Button2_Click})
            ##########################################################            
            
            # 
            # FormCucumberFeaturesExport
            # 
            $Form.AutoScaleDimensions = New-Object System.Drawing.SizeF(6, 13)
            $Form.ClientSize = New-Object System.Drawing.Size(584, 230)
            $Form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle #enum
            #$Form.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")))
            $Form.MaximizeBox = $false
            $Form.Name = "FormCucumberFeaturesExport"
            $Form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen #enum
            $Form.Text = "Cucumber - Export features to CSV file"
            $Form.AutoScaleMode = [System.Windows.Forms.AutoScaleMode]::Font #enum
            $Form.Cursor = [System.Windows.Forms.Cursors]::Default #enum

            $Form.Controls.Add($progressBar)

            $Form.Controls.Add($label1)
            $Form.Controls.Add($textBoxRootDir)
            $Form.Controls.Add($buttonDialogRoot)

            $Form.Controls.Add($label2)
            $Form.Controls.Add($textBoxOutputFile)
            $Form.Controls.Add($buttonDialogCSV)
            
            $Form.Controls.Add($checkBoxRunAtEnd)
            $Form.Controls.Add($labelMessage)
            $Form.Controls.Add($labelNote)
            $Form.Controls.Add($buttonGenerate)
            $Form.Controls.Add($buttonCloseOrCancel)
            
            #$FormClosed += new System.Windows.Forms.FormClosedEventHandler($FormCucumberFeaturesExport_FormClosed)
            #$Load += new System.EventHandler($FormCucumberFeaturesExport_Load)
            

$Form.ShowDialog()


