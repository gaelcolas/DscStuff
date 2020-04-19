@{

    # Script module or binary module file associated with this manifest.
    #RootModule = 'mod1.psm1'

    DscResourcesToExport = 'Rsrc4WithSubType','ClassRsrc4WithSubType'

    # Version number of this module.
    ModuleVersion = '0.0.2'

    # ID used to uniquely identify this module
    GUID = '81624038-5e17-40f8-8905-b1a87afe2226'

    # Author of this module
    Author = 'Gael Colas'

    # Company or vendor of this module
    CompanyName = ''

    # Copyright statement for this module
    Copyright = ''

    # Description of the functionality provided by this module
    # Description = ''

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Name of the Windows PowerShell host required by this module
    # PowerShellHostName = ''

    NestedModules = 'DscResources/ClassRsrc4WithSubType.psm1'

    CompatiblePSEditions = @('Desktop', 'Core')
}