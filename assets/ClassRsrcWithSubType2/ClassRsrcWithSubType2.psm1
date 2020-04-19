# Using module mod1 # Doing this leads to recursive module import and ends up throwing nesting limit error

# trying to redefine the module seems to work but can't serialize when trying
# an Invoke-DscResource with that property.
Class ClassSubType2 {
    [DscProperty()]
    [string] $Property1

    [bool] $Property3
}

enum Ensure
{
    Absent
    Present
}

[DscResource()]
class ClassRsrcWithSubType2 {

    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(Key)]
    [string]$Name

    [DscProperty()]
    [ClassSubType2] $SubTypeProperty

    [void] Set() {
        # Do something
    }

    [bool] Test() {
        if ($this.Ensure -eq [Ensure]::Present -and $this.Name -eq 'Present') {
            $present = $true
        }
        else {
            $present = $false
        }

        return $present
    }

    [ClassRsrcWithSubType2] Get() {

        if ($this.Name -eq 'Present') {
            $this.Ensure = [Ensure]::Present
            $this.SubTypeProperty = [ClassSubType2]::New()
            $this.SubTypeProperty.Property1 = 'plop'
        }
        else {
            $this.CreationTime = $null
            $this.Ensure = [Ensure]::Absent
        }

        return $this
    }

}

# enum myValues {
#     value1
#     value2
# }
