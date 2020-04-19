#Using module mod1 # Doing this leads to recursive module import and ends up throwing nesting limit error
Class ClassSubType {
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
class ClassRsrcWithSubType {

    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(Key)]
    [string]$Name

    [DscProperty()]
    [ClassSubType] $SubTypeProperty

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

    [ClassRsrcWithSubType] Get() {

        if ($this.Name -eq 'Present') {
            $this.Ensure = [Ensure]::Present
            $this.SubTypeProperty = [ClassSubType]::New()
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
