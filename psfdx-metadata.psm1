function Invoke-Sfdx {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true)][string] $Command)        
    Write-Verbose $Command
    return Invoke-Expression -Command $Command
}

function Show-SfdxResult {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true)][psobject] $Result)           
    $result = $Result | ConvertFrom-Json
    if ($result.status -ne 0) {
        Write-Debug $result
        throw ($result.message)
    }
    return $result.result
}

function Retrieve-SalesforceComponent {
    [CmdletBinding()]
    Param(        
        [Parameter(Mandatory = $false)][string][ValidateSet(
            'All',
            'ActionLinkGroupTemplate',
            'AnalyticSnapshot',
            'AnimationRule',
            'ApexClass',
            'ApexComponent',
            'ApexEmailNotifications',
            'ApexPage',
            'ApexTestSuite',
            'ApexTrigger',
            'AppMenu',
            'AppointmentSchedulingPolicy',
            'ApprovalProcess',
            'AssignmentRules',
            'AuraDefinitionBundle',
            'AuthProvider',
            'AutoResponseRules',
            'BlacklistedConsumer',
            'BrandingSet',
            'CallCenter',
            'CallCoachingMediaProvider',
            'CanvasMetadata',
            'Certificate',
            'ChannelLayout',
            'ChatterExtension',
            'CleanDataService',
            'Community',
            'ConnectedApp',
            'ContentAsset',
            'CorsWhitelistOrigin',
            'CspTrustedSite',
            'CustomApplication',
            'CustomApplicationComponent',
            'CustomFeedFilter',
            'CustomHelpMenuSection',
            'CustomIndex',
            'CustomLabels',
            'CustomMetadata',
            'CustomNotificationType',
            'CustomObject',
            'CustomObjectTranslation',
            'CustomPageWebLink',
            'CustomPermission',
            'CustomSite',
            'CustomTab',
            'Dashboard',
            'DataCategoryGroup',
            'DelegateGroup',
            'Document',
            'DuplicateRule',
            'EclairGeoData',
            'EmailServicesFunction',
            'EmailTemplate',
            'EmbeddedServiceBranding',
            'EmbeddedServiceConfig',
            'EmbeddedServiceFlowConfig',
            'EmbeddedServiceMenuSettings',
            'EntityImplements',
            'EscalationRules',
            'ExternalDataSource',
            'ExternalServiceRegistration',
            'FlexiPage',
            'Flow',
            'FlowCategory',
            'FlowDefinition',
            'GatewayProviderPaymentMethodType',
            'GlobalValueSet',
            'GlobalValueSetTranslation',
            'Group',
            'HomePageComponent',
            'HomePageLayout',
            'IframeWhiteListUrlSettings',
            'InboundNetworkConnection',
            'InstalledPackage',
            'Layout',
            'LeadConvertSettings',
            'Letterhead',
            'LightningBolt',
            'LightningComponentBundle',
            'LightningExperienceTheme',
            'LightningMessageChannel',
            'LightningOnboardingConfig',
            'LiveChatSensitiveDataRule',
            'ManagedContentType',
            'MatchingRules',
            'MobileApplicationDetail',
            'MutingPermissionSet',
            'MyDomainDiscoverableLogin',
            'NamedCredential',
            'NetworkBranding',
            'NotificationTypeConfig',
            'OauthCustomScope',
            'OutboundNetworkConnection',
            'PathAssistant',
            'PaymentGatewayProvider',
            'PermissionSet',
            'PermissionSetGroup',
            'PlatformCachePartition',
            'PlatformEventChannel',
            'PlatformEventChannelMember',
            'PlatformEventSubscriberConfig',
            'PostTemplate',
            'Profile',
            'ProfilePasswordPolicy',
            'ProfileSessionSetting',
            'Prompt',
            'Queue',
            'QuickAction',
            'RecommendationStrategy',
            'RecordActionDeployment',
            'RedirectWhitelistUrl',
            'RemoteSiteSetting',
            'Report',
            'ReportType',
            'Role',
            'SamlSsoConfig',
            'Scontrol',
            'Settings',
            'SharingRules',
            'SharingSet',
            'SiteDotCom',
            'Skill',
            'StandardValueSet',
            'StandardValueSetTranslation',
            'StaticResource',
            'SynonymDictionary',
            'TopicsForObjects',
            'TransactionSecurityPolicy',
            'UserProvisioningConfig',
            'Workflow'
        )] $Type,
        [Parameter(Mandatory = $false)][string] $Name,
        [Parameter(Mandatory = $true)][string] $Username
    )  

    # Retrieve all Meta Types
    if ($Type -eq 'All') {
        $metaTypes = Get-SalesforceMetaTypes -Username $Username    
        $count = 0
        foreach ($metaType in $metaTypes) {
            Invoke-Sfdx -Command "sfdx force:source:retrieve --metadata $metaType --targetusername $Username"        
            $count = $count + 1   
            Write-Progress -Activity 'Getting Salesforce MetaData' -Status $metaType -PercentComplete (($count / $metaTypes.count) * 100) 
        }
        return
    }

    $command = "sfdx force:source:retrieve --metadata $Type"
    if ($Name) {
        $command += ":$Name"
    }
    $command += " --targetusername $Username"
    Invoke-Sfdx -Command $command
}

function Retrieve-SalesforceField {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string] $ObjectName, 
        [Parameter(Mandatory = $true)][string] $FieldName, 
        [Parameter(Mandatory = $true)][string] $Username)    
    $command = "sfdx force:source:retrieve --metadata CustomField:$ObjectName.$FieldName"
    $command += " --targetusername $Username"
    Invoke-Sfdx -Command $command
}

function Deploy-SalesforceComponent {
    [CmdletBinding()]
    Param(        
        [Parameter(Mandatory = $false)][string][ValidateSet(
            'ActionLinkGroupTemplate',
            'AnalyticSnapshot',
            'AnimationRule',
            'ApexClass',
            'ApexComponent',
            'ApexEmailNotifications',
            'ApexPage',
            'ApexTestSuite',
            'ApexTrigger',
            'AppMenu',
            'AppointmentSchedulingPolicy',
            'ApprovalProcess',
            'AssignmentRules',
            'AuraDefinitionBundle',
            'AuthProvider',
            'AutoResponseRules',
            'BlacklistedConsumer',
            'BrandingSet',
            'CallCenter',
            'CallCoachingMediaProvider',
            'CanvasMetadata',
            'Certificate',
            'ChannelLayout',
            'ChatterExtension',
            'CleanDataService',
            'Community',
            'ConnectedApp',
            'ContentAsset',
            'CorsWhitelistOrigin',
            'CspTrustedSite',
            'CustomApplication',
            'CustomApplicationComponent',
            'CustomFeedFilter',
            'CustomHelpMenuSection',
            'CustomIndex',
            'CustomLabels',
            'CustomMetadata',
            'CustomNotificationType',
            'CustomObject',
            'CustomObjectTranslation',
            'CustomPageWebLink',
            'CustomPermission',
            'CustomSite',
            'CustomTab',
            'Dashboard',
            'DataCategoryGroup',
            'DelegateGroup',
            'Document',
            'DuplicateRule',
            'EclairGeoData',
            'EmailServicesFunction',
            'EmailTemplate',
            'EmbeddedServiceBranding',
            'EmbeddedServiceConfig',
            'EmbeddedServiceFlowConfig',
            'EmbeddedServiceMenuSettings',
            'EntityImplements',
            'EscalationRules',
            'ExternalDataSource',
            'ExternalServiceRegistration',
            'FlexiPage',
            'Flow',
            'FlowCategory',
            'FlowDefinition',
            'GatewayProviderPaymentMethodType',
            'GlobalValueSet',
            'GlobalValueSetTranslation',
            'Group',
            'HomePageComponent',
            'HomePageLayout',
            'IframeWhiteListUrlSettings',
            'InboundNetworkConnection',
            'InstalledPackage',
            'Layout',
            'LeadConvertSettings',
            'Letterhead',
            'LightningBolt',
            'LightningComponentBundle',
            'LightningExperienceTheme',
            'LightningMessageChannel',
            'LightningOnboardingConfig',
            'LiveChatSensitiveDataRule',
            'ManagedContentType',
            'MatchingRules',
            'MobileApplicationDetail',
            'MutingPermissionSet',
            'MyDomainDiscoverableLogin',
            'NamedCredential',
            'NetworkBranding',
            'NotificationTypeConfig',
            'OauthCustomScope',
            'OutboundNetworkConnection',
            'PathAssistant',
            'PaymentGatewayProvider',
            'PermissionSet',
            'PermissionSetGroup',
            'PlatformCachePartition',
            'PlatformEventChannel',
            'PlatformEventChannelMember',
            'PlatformEventSubscriberConfig',
            'PostTemplate',
            'Profile',
            'ProfilePasswordPolicy',
            'ProfileSessionSetting',
            'Prompt',
            'Queue',
            'QuickAction',
            'RecommendationStrategy',
            'RecordActionDeployment',
            'RedirectWhitelistUrl',
            'RemoteSiteSetting',
            'Report',
            'ReportType',
            'Role',
            'SamlSsoConfig',
            'Scontrol',
            'Settings',
            'SharingRules',
            'SharingSet',
            'SiteDotCom',
            'Skill',
            'StandardValueSet',
            'StandardValueSetTranslation',
            'StaticResource',
            'SynonymDictionary',
            'TopicsForObjects',
            'TransactionSecurityPolicy',
            'UserProvisioningConfig',
            'Workflow'
        )] $Type = 'ApexClass',       
        [Parameter(Mandatory = $false)][string] $Name,       
        [Parameter(Mandatory = $true)][string] $Username
    )    
    $command = "sfdx force:source:deploy --metadata $Type"
    if ($Name) { 
        $command += ":$Name" 
    }
    $command += " --targetusername $Username"
    $command += " --json"
    
    $result = Invoke-Sfdx -Command $command
    return Show-SfdxResult -Result $result    
}

function Describe-SalesforceObjects {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string] $Username,
        [Parameter(Mandatory = $false)][string][ValidateSet('all', 'custom', 'standard')] $ObjectTypeCategory = 'all'
    ) 
    $command = "sfdx force:schema:sobject:list"
    $command += " --sobjecttypecategory all"
    $command += " --targetusername $Username"
    $command += " --json"
    $result = Invoke-Sfdx -Command $command
    return Show-SfdxResult -Result $result    
}

function Describe-SalesforceObject {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string] $Name,    
        [Parameter(Mandatory = $true)][string] $Username,
        [Parameter(Mandatory = $false)][switch] $UseToolingApi
    ) 
    $command = "sfdx force:schema:sobject:describe"
    $command += " --sobjecttype $Name"
    if ($UseToolingApi) {
        $command += " --usetoolingapi"
    }    
    $command += " --targetusername $Username"
    $command += " --json"
    $result = Invoke-Sfdx -Command $command
    return Show-SfdxResult -Result $result
}

function Describe-SalesforceFields {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string] $ObjectName,    
        [Parameter(Mandatory = $true)][string] $Username,
        [Parameter(Mandatory = $false)][switch] $UseToolingApi        
    )         
    $result = Describe-SalesforceObject -ObjectName $ObjectName -Username $Username -UseToolingApi:$UseToolingApi 
    $result = $result.fields
    $result = $result | Select-Object name, label, type, byteLength
    return $result
}

function Describe-SalesforceCodeTypes {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true)][string] $Username)  
    $command = "sfdx force:mdapi:describemetadata"
    $command += " --targetusername $Username"
    $command += " --json"

    $result = Invoke-Sfdx -Command $command           
    $result = $result | ConvertFrom-Json
    $result = $result.result.metadataObjects
    $result = $result | Select-Object xmlName
    return $result
}

function Get-SalesforceMetaTypes {
    [CmdletBinding()]
    Param([Parameter(Mandatory = $true)][string] $Username)     
    $result = Invoke-Sfdx -Command "sfdx force:mdapi:describemetadata --targetusername $username --json"
    $result = $result | ConvertFrom-Json
    $result = $result.result.metadataObjects    
    $result = $result.xmlName | Sort-Object
    return $result
}

function Get-SalesforceApexClass {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true)][string] $Name,
        [Parameter(Mandatory = $true)][string] $Username
    )   
    $query = "SELECT Id, Name "
    $query += "FROM ApexClass "
    $query += "WHERE Name = '$Name'"
    $result = Select-SalesforceObjects -Query $query -Username $Username
    $result = $result | Select-Object Id, name
    return $result
}

Export-ModuleMember Retrieve-SalesforceComponent
Export-ModuleMember Retrieve-SalesforceField
Export-ModuleMember Deploy-SalesforceComponent

Export-ModuleMember Describe-SalesforceObjects
Export-ModuleMember Describe-SalesforceObject
Export-ModuleMember Describe-SalesforceFields
Export-ModuleMember Describe-SalesforceCodeTypes
Export-ModuleMember Get-SalesforceMetaTypes

Export-ModuleMember Get-SalesforceApexClass