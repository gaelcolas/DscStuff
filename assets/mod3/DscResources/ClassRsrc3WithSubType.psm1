Class ClassSubType3 {
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
class ClassRsrc3WithSubType {

    [DscProperty(Mandatory)]
    [Ensure] $Ensure

    [DscProperty(Key)]
    [string]$Name

    [DscProperty()]
    [ClassSubType3] $SubTypeProperty

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

    [ClassRsrc3WithSubType] Get() {

        if ($this.Name -eq 'Present') {
            $this.Ensure = [Ensure]::Present
            $this.SubTypeProperty = [ClassSubType3]::New()
            $this.SubTypeProperty.Property1 = 'plop'
        }
        else {
            $this.CreationTime = $null
            $this.Ensure = [Ensure]::Absent
        }

        return $this
    }

}
