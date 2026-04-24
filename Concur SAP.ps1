#
# Concur SAP.ps1 - Concur SAP
#
$Log_MaskableKeys = @(
    'Password',
    'proxy_password',
    'access_token',
    'company_request_token',
    'client_secret',
    'refresh_token'
)

$Global:AuthToken = $null
$Global:Proxy = @{}
$Global:ProxyInitialized = $false
$Global:IdentityUsers = [System.Collections.ArrayList]@()
$Global:IdentityUsers_Addresses = [System.Collections.ArrayList]@()
$Global:IdentityUsers_Emails = [System.Collections.ArrayList]@()
$Global:IdentityUsers_EmergencyContacts = [System.Collections.ArrayList]@()
$Global:IdentityUsers_PhoneNumbers = [System.Collections.ArrayList]@()
$Global:SpendUsers = [System.Collections.ArrayList]@()
$Global:SpendUsers_CustomData = [System.Collections.ArrayList]@()
$Global:SpendUsers_Delegate = [System.Collections.ArrayList]@()
$Global:SpendUsers_Approver = [System.Collections.ArrayList]@()
$Global:SpendUsers_ApproverLimit = [System.Collections.ArrayList]@()
$Global:SpendUsers_Roles = [System.Collections.ArrayList]@()
$Global:TravelUsers = [System.Collections.ArrayList]@()
$Global:TravelUsers_CustomFields = [System.Collections.ArrayList]@()

$Properties = @{
    FormField = @(
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'access';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'controlType';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'dataType';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'isCustom';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'isRequired';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'label';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'maxLength';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'name';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'schemas';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'sequence';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    IdentityUser = @(
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'active';            type = 'boolean';   objectfields = $null;             options = @('default','create_m','update_o') }
        @{ name = 'addresses';            type = 'table';   objectfields = $null;             options = @('default') }
        @{ name = 'dateOfBirth';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'displayName';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'emails';            type = 'table';   objectfields = $null;             options = @('default') }
        @{ name = 'emergencyContacts';            type = 'table';   objectfields = $null;           options = @('default') }
        @{ name = 'entitlements';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'externalId';            type = 'string';   objectfields = $null;             options = @('default','create_o') }
        @{ name = 'localeOverrides';            type = 'object';   objectfields = @("preferenceEndDayViewHour","preferenceFirstDayOfWeek","preferenceDateFormat","preferenceCurrencySymbolLocation","preferenceHourMinuteSeparator","preferenceDistance","preferenceDefaultCalView","preference24Hour","preferenceNumberFormat","preferenceStartDayViewHour","preferenceNegativeCurrencyFormat","preferenceNegativeNumberFormat");             options = @('default') }
        @{ name = 'meta';            type = 'object';   objectfields = @("resourceType","created","lastModified","version","location");             options = @('default') }
        @{ name = 'name';            type = 'object';   objectfields = @("honorificSuffix","formatted","familyName","givenName","familyNamePrefix","honorificPrefix","middleName");             options = @('default','create_o','update_o') }
        @{ name = 'nickname';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'phoneNumbers';            type = 'table';   objectfields = $null;             options = @('default') }
        @{ name = 'preferredLanguage';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'timezone';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'title';            type = 'string';   objectfields = $null;             options = @('default','create_o','update_o') }
        @{ name = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User';            type = 'object';   objectfields = @("terminationDate","companyId","department","organization","manager.value","manager.employeeNumber","costCenter","startDate","leavesOfAbsence","employeeNumber","division");             options = @('default','create_o','update_o'); alias = 'EnterpriseUser' }
        @{ name = 'userName';            type = 'string';   objectfields = $null;             options = @('default','create_m','update_o') }
    )
    IdentityUser_Address = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'country';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'locality';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'postalCode';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'region';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'streetAddress';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    IdentityUser_Email = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','add_m','delete_m') }
        @{ name = 'verified';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default','add_m') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default','add_m','delete_m') }
        @{ name = 'notifications';            type = 'boolean';   objectfields = $null;             options = @('default','add_o') }
    )
    IdentityUser_EmergencyContact = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'country';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'emails';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'locality';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'name';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'phones';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'postalCode';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'region';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'relationship';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'streetAddress';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    IdentityUser_PhoneNumber = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','add_m','delete_m') }
        @{ name = 'display';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'issuingCountry';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'notifications';            type = 'string';   objectfields = $null;             options = @('default','add_o') }
        @{ name = 'primary';            type = 'string';   objectfields = $null;             options = @('default','add_o') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default','add_m') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default','add_m','delete_m') }
    )
    Role = @(
        @{ name = 'roleCode';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'roleFullName';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'description';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'groupAware';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'isProductArea';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'productAreas';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendCategoryCode = @(
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'name';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser = @(
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'schemas';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'meta';            type = 'object';   objectfields = @("resourceType","created","lastModified","version","location");             options = @('default') }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User';            type = 'object';   objectfields = @("reimbursementCurrency","reimbursementType","ledgerCode","country","budgetCountryCode","stateProvince","locale","cashAdvanceAccountCode","testEmployee","nonEmployee","biManager.value");             options = @('default','create_o','update_o'); alias = 'SpendUser' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:UserPreference';            type = 'object';   objectfields = @("showImagingIntro","expenseAuditRequired","allowCreditCardTransArrivalEmails","allowReceiptImageAvailEmails","promptForCardTransactionsOnReport","autoAddTripCardTransOnReport","promptForReportPrintFormat","defaultReportPrintFormat","showTotalOnReport","showExpenseOnReport","showInstructHelpPanel","useQuickItinAsDefault","enableOcrForUi","enableOcrForEmail","enableTripBasedAssistant");             options = @('default','update_o'); alias = 'SpendUserPreference' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:InvoicePreference';            type = 'string';   objectfields = $null;             options = @('default','update_o'); alias = 'SpendInvoicePreference' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:Payroll';            type = 'string';   objectfields = $null;             options = @('default','update_o'); alias = 'EnterprisePayroll' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:WorkflowPreference';            type = 'object';   objectfields = @("emailStatusChangeOnCashAdvance","emailAwaitApprovalOnCashAdvance","emailStatusChangeOnReport","emailAwaitApprovalOnReport","promptForApproverOnReportSubmit","emailStatusChangeOnTravelRequest","emailAwaitApprovalOnTravelRequest","promptForApproverOnTravelRequestSubmit","emailStatusChangeOnPayment","emailAwaitApprovalOnPayment","promptForApproverOnPaymentSubmit","emailOnPurchaseRequestStatusChange","emailOnPurchaseRequestAwaitApproval","promptForPurchaseRequestApproverOnSubmit");             options = @('default','update_o'); alias = 'SpendWorkflowPreference' }
    )
    SpendUser_CustomData = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','create_m','update_m') }
        @{ name = 'spendUser_id';            type = 'string';   objectfields = $null;             options = @('default','create_m','update_m') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default','create_m','update_m') }
        @{ name = 'syncGuid';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'href';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser_Approver = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'spendUser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approver_value';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'primary';            type = 'boolean';   objectfields = $null;             options = @('default') }
    )
    SpendUser_ApproverLimit = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'spendUser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalGroup';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalLimit';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalType';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'exceptionApprovalAuthority';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'reimbursementCurrency';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser_Delegate = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'spendUser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'canApprove';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canPrepare';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canPrepareForApproval';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canReceiveApprovalEmail';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canReceiveEmail';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canSubmit';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canSubmitTravelRequest';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canUseBi';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'canViewReceipt';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'delegate_value';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser_Role = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'spendUser_id';            type = 'string';   objectfields = $null;             options = @('default','add_m','remove_m') }
        @{ name = 'roleName';            type = 'string';   objectfields = $null;             options = @('default','add_m','remove_m') }
        @{ name = 'roleGroups';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    TravelUser = @(
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'urn:ietf:params:scim:schemas:extension:travel:2.0:User';            type = 'object';   objectfields = @("ruleClass.name","ruleClass.id","travelCrsName","name.namePrefix","name.givenName","name.hasNoMiddleName","name.middleName","name.familyName","name.honorificSuffix","travelNameRemark","gender","orgUnit","manager.value","manager.employeeNumber","groups","eReceiptOptIn" );             options = @('default','create_o','update_o'); alias = 'TravelUser' }
    )
    TravelUser_CustomField = @(
        @{ name = 'nim_id';            type = 'string';   objectfields = $null;             options = @('default','key') }    
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default') }        
        @{ name = 'traveluser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'name';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default') }
    )
}

#
# System functions
#
function Idm-SystemInfo {
    param (
        # Operations
        [switch] $Connection,
        [switch] $TestConnection,
        [switch] $Configuration,
        # Parameters
        [string] $ConnectionParams
    )

    Log info "-Connection=$Connection -TestConnection=$TestConnection -Configuration=$Configuration -ConnectionParams='$ConnectionParams'"

    if ($Connection) {
        @(
            @{
                name = 'geolocation'
                type = 'textbox'
                label = 'Geo Location'
                description = ''
                value = 'us.api.concursolutions.com'
                require = $true
            }
            @{
                name = 'company_uuid'
                type = 'textbox'
                label = 'Company UUID'
                label_indent = $true
                tooltip = 'Use the Concur SAP Company Request Token Self-Service Tool to get this information. A refresh token has a six month lifetime'
                value = ''
                require = $true
            }
            @{
                name = 'company_request_token'
                type = 'textbox'
                password = $true
                label = 'Company Request Token'
                label_indent = $true
                tooltip = 'Use the Concur SAP Company Request Token Self-Service Tool to get this information. A refresh token has a six month lifetime'
                value = ''
                require = $true
            }
            @{
                name = 'client_id'
                type = 'textbox'
                label = 'Client ID'
                label_indent = $true
                tooltip = 'Use the Concur SAP OAuth 2.0 Application Management Tool to generate Client IDs (App IDs) and Client Secrets without contacting SAP Concur support'
                value = ''
                require = $true
            }
            @{
                name = 'client_secret'
                type = 'textbox'
                password = $true
                label = 'Client Secret'
                label_indent = $true
                tooltip = 'Use the Concur SAP OAuth 2.0 Application Management Tool to generate Client IDs (App IDs) and Client Secrets without contacting SAP Concur support'
                value = ''
                require = $true
            }
            @{
                name = 'refresh_token'
                type = 'textbox'
                password = $true
                label = 'Refresh Token'
                label_indent = $true
                tooltip = ''
                value = ''
                require = $true
            }
            @{
                name = 'use_proxy'
                type = 'checkbox'
                label = 'Use Proxy'
                description = 'Use Proxy server for requests'
                value = $false # Default value of checkbox item
            }
            @{
                name = 'proxy_address'
                type = 'textbox'
                label = 'Proxy Address'
                description = 'Address of the proxy server'
                value = 'http://127.0.0.1:8888'
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'use_proxy_credentials'
                type = 'checkbox'
                label = 'Use Proxy Credentials'
                description = 'Use credentials for proxy'
                value = $false
                disabled = '!use_proxy'
                hidden = '!use_proxy'
            }
            @{
                name = 'proxy_username'
                type = 'textbox'
                label = 'Proxy Username'
                label_indent = $true
                description = 'Username account'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'proxy_password'
                type = 'textbox'
                password = $true
                label = 'Proxy Password'
                label_indent = $true
                description = 'User account password'
                value = ''
                disabled = '!use_proxy_credentials'
                hidden = '!use_proxy_credentials'
            }
            @{
                name = 'nr_of_retries'
                type = 'textbox'
                label = 'Max. number of retry attempts'
                description = ''
                value = 5
            }
            @{
                name = 'retryDelay'
                type = 'textbox'
                label = 'Seconds to wait for retry'
                description = ''
                value = 2
            }
            @{
                name = 'nr_of_threads'
                type = 'textbox'
                label = 'Max. number of simultaneous requests'
                description = ''
                value = 20
            }
            @{
                name = 'nr_of_sessions'
                type = 'textbox'
                label = 'Max. number of simultaneous sessions'
                description = ''
                value = 1
            }
            @{
                name = 'sessions_idle_timeout'
                type = 'textbox'
                label = 'Session cleanup idle time (minutes)'
                description = ''
                value = 1
            }
        )
    }

    if ($TestConnection) {
        $system_params = ConvertFrom-Json2 $ConnectionParams
        Execute-Request -SystemParams $system_params -Method "GET" -Uri "profile/identity/v4.1/Users?count=1" -BypassPagination $true | Out-Null
    }

    if ($Configuration) {
        @()
    }

    Log info "Done"
}

function Idm-OnUnload {
    $Global:AuthToken = $null
    $Global:Proxy = @{}
    $Global:ProxyInitialized = $false
    $Global:IdentityUsers.Clear()
    $Global:IdentityUsers_Addresses.Clear()
    $Global:IdentityUsers_Emails.Clear()
    $Global:IdentityUsers_EmergencyContacts.Clear()
    $Global:IdentityUsers_PhoneNumbers.Clear()
    $Global:SpendUsers.Clear()
    $Global:SpendUsers_CustomData.Clear()
    $Global:SpendUsers_Delegate.Clear()
    $Global:SpendUsers_Approver.Clear()
    $Global:SpendUsers_ApproverLimit.Clear()
    $Global:SpendUsers_Roles.Clear()
    $Global:TravelUsers.Clear()
    $Global:TravelUsers_CustomFields.Clear()
}

#
# Object CRUD functions
#
function Idm-formFieldsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'FormField'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {
            $uri = "profile/spend/v4.1/FormFields"
        
            $splat = @{
                SystemParams = $system_params
                Method = "GET"
                Uri = $uri                    
            }

            $response = Execute-Request @splat
            
            # Precompute property template
            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {
                if($propertiesHT[$prop].Type -eq 'object') {
                    $colPrefix = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                    foreach($path in $propertiesHT[$prop].objectfields) {
                        $template["$($colPrefix)_$($path.Replace('.','_'))"] = $null
                    }
                    continue
                }

                $colName = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                $template[$colName] = $null
            }

            $propertyNameSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$properties.Name, [System.StringComparer]::Ordinal)
            foreach($item in $response.Resources) {
                $row = [PSCustomObject]([ordered]@{} + $template)
                foreach($prop in $item.PSObject.Properties) {
                    $schemaProp = $propertiesHT[$prop.Name]

                    if ($null -ne $schemaProp -and $propertyNameSet.Contains($prop.Name)) {
                        $colName = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                        $row.($colName) = $prop.Value
                    }
                    
                }
                $row

                
            }
        }
}

function Idm-identity_usersRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'IdentityUser'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {

            if(     $Global:IdentityUsers.count -lt 1) {   

                $uri = "profile/identity/v4.1/Users"             
            
                $splat = @{
                    SystemParams = $system_params
                    Method = "GET"
                    Uri = $uri                    
                    Body = @{
                        attributes = "active,addresses,dateOfBirth,displayName,emails,emergencyContacts,entitlements,externalId,id,localeOverrides,meta,name,nickName,phoneNumbers,preferredLanguage,timezone,title,userName,urn:ietf:params:scim:schemas:extension:enterprise:2.0:User"
                    }
                    Path = "Resources"
                }

                $response = Execute-Request @splat
                [void]$Global:IdentityUsers.AddRange($response)
            }

            # Precompute property template
            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {
                if($propertiesHT[$prop].Type -eq 'object') {
                    $colPrefix = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                    foreach($path in $propertiesHT[$prop].objectfields) {
                        $template["$($colPrefix)_$($path.Replace('.','_'))"] = $null
                    }
                    continue
                }

                $colName = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                $template[$colName] = $null
            }

            $propertyNameSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$properties.Name, [System.StringComparer]::Ordinal)
            $tableVarMap = @{
                'Addresses'         = $Global:IdentityUsers_Addresses
                'Emails'            = $Global:IdentityUsers_Emails
                'EmergencyContacts' = $Global:IdentityUsers_EmergencyContacts
                'PhoneNumbers'      = $Global:IdentityUsers_PhoneNumbers
            }
            foreach($item in $Global:IdentityUsers) {
                $row = [PSCustomObject]([ordered]@{} + $template)
                foreach($prop in $item.PSObject.Properties) {
                    $schemaProp = $propertiesHT[$prop.Name]

                    if($schemaProp.Type -eq 'table') {
                        $ucFirst = $prop.Name.Substring(0,1).ToUpper() + $prop.Name.Substring(1)
                        $globalVar = $tableVarMap[$ucFirst]
                            foreach($subItem in $prop.Value) {
                                $table_template = [ordered]@{}
                                $table_template['nim_id'] = Get-ObjectHash -Object $subItem
                                $table_template['identityuser_id'] = $item.id
                                foreach($subProperty in $subItem.PSObject.Properties) {
                                    $table_template[$subProperty.Name] = $subProperty.Value
                                }
                                [void]$globalVar.Add([PSCustomObject]$table_template)
                            }
                        continue
                    }

                    if($schemaProp.Type -eq 'object') {
                        $colPrefix = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                        foreach($path in $schemaProp.objectfields) {
                            $colName = "$($colPrefix)_$($path.Replace('.','_'))"
                            $val = Resolve-NestedValue $prop.Value $path
                            $rowProp = $row.PSObject.Properties[$colName]
                            if ($null -ne $rowProp) {
                                $rowProp.Value = $val
                            } else {
                                $row | Add-Member -NotePropertyName $colName -NotePropertyValue $val
                            }
                        }
                        continue
                    }

                    if ($null -ne $schemaProp -and $propertyNameSet.Contains($prop.Name)) {
                        $colName = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                        $row.($colName) = $prop.Value
                    }
                }

                $row
            }
        }
}

function Idm-identity_userCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_m' -or $_.options -contains 'key' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'create_m' -or $_.options -contains 'create_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users"             
        
        $alias = "{0}_" -f ($Global:Properties.$Class | ? { $_.Name -eq 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'}).Alias
        $body = [PSObject]@{
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' = [PSObject]@{}
        }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name.StartsWith($alias)) {
                $fieldname = ($prop.Name.Replace($alias,''))
                if($fieldname.contains('_')) {
                    $field = $fieldname.split('_')
                    $objname = $field[0]
                    $fieldname = $field[1]
                    $body.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.$objname = @{ $fieldname = $prop.Value }
                } else {
                    $body.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.$fieldname = $prop.Value
                }
            } elseif($prop.Name.Contains("_")) {
                $field = ($prop.Name).split('_')
                $objname = $field[0]
                $fieldname = $field[1]

                if(([PSCustomObject]$body).PSObject.Properties.Name.Contains($objName) ) {
                    $body.$objname.$fieldname = $prop.Value 
                } else {
                    $body.$objname = [PSObject]@{ $fieldname = $prop.Value }
                }
            } else {
                $body.($prop.Name) = $prop.Value
            }
            
        }

        $splat = @{
            SystemParams = $system_params
            Method = "POST"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
        $function_params.id = $response.id
    
        LogIO info "identityUserCreate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-identity_userUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' -or $_.options -contains 'update_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'update_m' -or $_.options -contains 'update_o' -or $_.options -contains 'optional' -or $_.options.Contains('key') ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.id            
        
        $alias = "{0}_" -f ($Global:Properties.$Class | ? { $_.Name -eq 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'}).Alias
        $body = [PSObject]@{
            'Operations' = [System.Collections.ArrayList]@()
        }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'id') { continue }

            if($prop.Name.StartsWith($alias)) {
                $fieldname = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User:{0}' -f $prop.Name.replace($alias,'')
            } elseif($prop.Name.Contains("_")) {
                $fieldname = ($prop.Name.Replace("_",'.'))
            } else {
                $fieldname = $prop.Name
            }
            
            [void]$body.Operations.Add([PSObject]@{
                'op' ='replace'
                'path' = $fieldname
                'value' = $prop.Value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "identityUserUpdate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-identity_userDelete {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'key') } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.id             

        $splat = @{
            SystemParams = $system_params
            Method = "DELETE"
            Uri = $uri                    
        }
        
        $response = Execute-Request @splat
    
        LogIO info "identityUserDelete" -out $response
    }

    Log verbose "Done"
}

function Idm-identity_users_addressesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'IdentityUser_Address'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:IdentityUsers.Count -eq 0) {
            Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:IdentityUsers_Addresses
}

function Idm-identity_users_emailsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'IdentityUser_Email'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:IdentityUsers.Count -eq 0) {
            Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:IdentityUsers_Emails
}

function Idm-identity_users_emailAdd {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser_Email'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'add_m' -or $_.options -contains 'add_o' -or $_.options -contains 'optional' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.identityuser_id             
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'add'
            'path' = 'emails'
            'value' = @([PSObject]@{

            })
        }
        
        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'identityuser_id') { continue }
            $newObj.value[0].($prop.Name) = $prop.Value
        }

        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        $function_params.nim_id = Get-ObjectHash -Object $function_params
        LogIO info "identityUserEmailAdd" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-identity_users_emailRemove {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser_Email'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'delete_m' -or $_.options -contains 'key'  } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'delete_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'delete_m' -or $_.options -contains 'delete_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.identityuser_id             
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= @([PSObject]@{
                'op' = 'remove'
                'path' = 'emails[value eq "{0}"]' -f $function_params.value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat

        LogIO info "identityUserEmailRemove"
    }
    
    Log verbose "Done"
}

function Idm-identity_users_emergencyContactsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'IdentityUser_EmergencyContact'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:IdentityUsers.Count -eq 0) {
            Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:IdentityUsers_EmergencyContacts
}

function Idm-identity_users_phoneNumbersRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'IdentityUser_PhoneNumber'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:IdentityUsers.Count -eq 0) {
            Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:IdentityUsers_PhoneNumbers
}

function Idm-identity_users_phoneNumberAdd {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser_PhoneNumber'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'add_m' -or $_.options -contains 'add_o' -or $_.options -contains 'optional' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.identityuser_id             
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'add'
            'path' = 'phoneNumbers'
            'value' = @([PSObject]@{

            })
        }
        
        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'identityuser_id') { continue }
            $newObj.value[0].($prop.Name) = $prop.Value
        }

        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        $function_params.nim_id = Get-ObjectHash -Object $function_params
        LogIO info "identityUserPhoneNumberAdd" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-identity_users_phoneNumberRemove {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'IdentityUser_PhoneNumber'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'delete_m' -or $_.options -contains 'key'  } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'delete_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'delete_m' -or $_.options -contains 'delete_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/identity/v4.1/Users/{0}" -f $function_params.identityuser_id             
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= @([PSObject]@{
                'op' = 'remove'
                'path' = 'phoneNumbers[value eq "{0}"]' -f $function_params.value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat

        LogIO info "identityUserPhoneNumberRemove"
    }
    
    Log verbose "Done"
}

function Idm-rolesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'Role'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            
        } else {
            $uri = "profile/spend/v4/Users/roleCodes"             
        
            $splat = @{
                SystemParams = $system_params
                Method = "GET"
                Uri = $uri                    
            }

            $response = Execute-Request @splat
            
            # Precompute property template
            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }

            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {
                if($propertiesHT[$prop].Type -eq 'object') {
                    $colPrefix = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                    foreach($path in $propertiesHT[$prop].objectfields) {
                        $template["$($colPrefix)_$($path.Replace('.','_'))"] = $null
                    }
                    continue
                }

                $colName = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                $template[$colName] = $null
            }

            $propertyNameSet = [System.Collections.Generic.HashSet[string]]::new([string[]]$properties.Name, [System.StringComparer]::Ordinal)
            foreach($area in $response.PSObject.Properties) {
                foreach($item in $area.Value) {
                    $row = [PSCustomObject]([ordered]@{} + $template)
                    $row.type = $area.Name
                    foreach($prop in $item.PSObject.Properties) {
                        $schemaProp = $propertiesHT[$prop.Name]

                        if ($null -ne $schemaProp -and $propertyNameSet.Contains($prop.Name)) {
                            $colName = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                            $row.($colName) = $prop.Value
                        }
                        
                    }

                    $row
                }

            }
        }
}

function Idm-spendCategoryCodesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendCategoryCode'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        $items = @(
            [pscustomobject]@{ ID = 'ABFEE'; Name = 'Agent/Booking Fees' }
            [pscustomobject]@{ ID = 'ACCNT'; Name = 'Accounting' }
            [pscustomobject]@{ ID = 'ADVTG'; Name = 'Advertising/Marketing' }
            [pscustomobject]@{ ID = 'AIRFE'; Name = 'Airline Fees' }
            [pscustomobject]@{ ID = 'AIRFR'; Name = 'Airfare' }
            [pscustomobject]@{ ID = 'CARRT'; Name = 'Car Rental' }
            [pscustomobject]@{ ID = 'CARXX'; Name = 'Car Related' }
            [pscustomobject]@{ ID = 'CASHA'; Name = 'Cash Advance - Not Partially Approvable' }
            [pscustomobject]@{ ID = 'CASHN'; Name = 'Cash Advance - Standard' }
            [pscustomobject]@{ ID = 'COCAR'; Name = 'Company Car - Fixed Expense' }
            [pscustomobject]@{ ID = 'COCRM'; Name = 'Company Car - Mileage Reimbursement' }
            [pscustomobject]@{ ID = 'COMPU'; Name = 'Computer' }
            [pscustomobject]@{ ID = 'CONSL'; Name = 'Consulting Services' }
            [pscustomobject]@{ ID = 'DONAT'; Name = 'Donations' }
            [pscustomobject]@{ ID = 'ENTER'; Name = 'Entertainment' }
            [pscustomobject]@{ ID = 'FACLT'; Name = 'Facility' }
            [pscustomobject]@{ ID = 'FEESD'; Name = 'Fees/Dues' }
            [pscustomobject]@{ ID = 'FINAN'; Name = 'Financial Services' }
            [pscustomobject]@{ ID = 'GASXX'; Name = 'Gas' }
            [pscustomobject]@{ ID = 'GIFTS'; Name = 'Gifts' }
            [pscustomobject]@{ ID = 'GOODW'; Name = 'Goodwill' }
            [pscustomobject]@{ ID = 'GRTRN'; Name = 'Ground Transportation' }
            [pscustomobject]@{ ID = 'INCTA'; Name = 'Incidental - Count in Daily Incidental Allowance' }
            [pscustomobject]@{ ID = 'INSUR'; Name = 'Insurance' }
            [pscustomobject]@{ ID = 'JANTR'; Name = 'Janitorial' }
            [pscustomobject]@{ ID = 'JGTRN'; Name = 'Ground Transportation - Japanese' }
            [pscustomobject]@{ ID = 'LEGAL'; Name = 'Legal Services' }
            [pscustomobject]@{ ID = 'LODGA'; Name = 'Lodging - Track Room Rate Spending' }
            [pscustomobject]@{ ID = 'LODGN'; Name = 'Lodging - Do Not Track Room Rate Spending' }
            [pscustomobject]@{ ID = 'LODGT'; Name = 'Lodging Tax' }
            [pscustomobject]@{ ID = 'LODGX'; Name = 'Lodging' }
            [pscustomobject]@{ ID = 'MEALA'; Name = 'Meal - Count in Daily Meal Allowance' }
            [pscustomobject]@{ ID = 'MEALN'; Name = 'Meal - Do Not Count in Daily Meal Allowance' }
            [pscustomobject]@{ ID = 'MEALS'; Name = 'Meal' }
            [pscustomobject]@{ ID = 'MEETG'; Name = 'Meetings' }
            [pscustomobject]@{ ID = 'MFUEL'; Name = 'Fuel For Mileage' }
            [pscustomobject]@{ ID = 'OFFIC'; Name = 'Office Supplies' }
            [pscustomobject]@{ ID = 'OSUPP'; Name = 'Other Supplies' }
            [pscustomobject]@{ ID = 'OTHER'; Name = 'Other' }
            [pscustomobject]@{ ID = 'PRCAR'; Name = 'Personal Car - Fixed Expense' }
            [pscustomobject]@{ ID = 'PRCRM'; Name = 'Personal Car - Mileage Reimbursement' }
            [pscustomobject]@{ ID = 'PRKNG'; Name = 'Personal Car - Parking Expense' }
            [pscustomobject]@{ ID = 'PRNTG'; Name = 'Printing/Reproduction' }
            [pscustomobject]@{ ID = 'PROFS'; Name = 'Professional Services' }
            [pscustomobject]@{ ID = 'RAILX'; Name = 'Train' }
            [pscustomobject]@{ ID = 'RENTL'; Name = 'Rent' }
            [pscustomobject]@{ ID = 'SHIPG'; Name = 'Shipping' }
            [pscustomobject]@{ ID = 'STAFF'; Name = 'Staffing' }
            [pscustomobject]@{ ID = 'SUBSC'; Name = 'Subscription/Publication' }
            [pscustomobject]@{ ID = 'TELEC'; Name = 'Telecom/Internet' }
            [pscustomobject]@{ ID = 'TRADE'; Name = 'Trade/Convention' }
            [pscustomobject]@{ ID = 'TRAIN'; Name = 'Training' }
            [pscustomobject]@{ ID = 'UTLTS'; Name = 'Utilities' }
        )

        $items
}

function Idm-spend_usersRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if(     $Global:SpendUsers.count -lt 1) {  

            if ($Global:IdentityUsers.Count -eq 0) {
                Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
            }

            # Precompute property template
            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }
            
            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {

                if($propertiesHT[$prop].Type -eq 'object') {
                    $colPrefix = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                    foreach($path in $propertiesHT[$prop].objectfields) {
                        $template["$($colPrefix)_$($path.Replace('.','_'))"] = $null
                    }
                    continue
                }

                $colName = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                $template[$colName] = $null
            }

            # Prepare runspace pool
            $cancellationSource = [System.Threading.CancellationTokenSource]::new()

            $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
            $runspacePool.Open()
            $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

            # Index for tracking
            $index = 0

            $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef3 = "function Initialize-Proxy { $((Get-Command Initialize-Proxy -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef4 = "function Resolve-NestedValue { $((Get-Command Resolve-NestedValue -CommandType Function).ScriptBlock.ToString()) }"

            # Capture once — stable for the entire sync
            $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
            $authTokenSnapshot       = $Global:AuthToken
            $proxyInitializedSnapshot = $Global:ProxyInitialized

            foreach ($item in $Global:IdentityUsers) {
                $runspace = [powershell]::Create()

                [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript($funcDef3).AddScript($funcDef4).AddScript({
                    param($item, $system_params, $Class, $template, $index, $properties, $propertiesHT, $proxy, $authToken, $proxyInitialized)

                    $Global:Proxy            = $proxy
                    $Global:AuthToken        = $authToken
                    $Global:ProxyInitialized = $proxyInitialized

                    $itemResult = @{
                        rawResult = $null
                        result = $null
                        logMessage = $null
                    }

                    $splat = @{
                        SystemParams = $system_params
                        Method = "GET"
                        Uri = "profile/spend/v4.1/Users/$($item.id)"
                        LoggingEnabled = $false
                    }

                    try {
                        $response = Execute-Request @splat
                    } catch {
                        $itemResult.logMessage = "Retrieve User Info [$($item.id)] - $_"
                        return $itemResult
                    }
                    $response = $response[0]

                    $row = [PSCustomObject]([ordered]@{} + $template)
                    $row.'nim_id' = Get-ObjectHash -Object $response

                    $itemResult.rawResult = $response

                    foreach ($prop in $response.PSObject.Properties) {
                        $schemaProp = $propertiesHT[$prop.Name]
                        if($schemaProp.Type -eq 'object') {
                            $colPrefix = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                            foreach($path in $schemaProp.objectfields) {
                                $row.("$($colPrefix)_$($path.Replace('.','_'))") = Resolve-NestedValue $prop.Value $path
                            }
                            continue
                        }

                        $colName = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                        $row.($colName) = $prop.Value
                    }

                    $itemResult.result = $row

                    return $itemResult
                }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($template).AddArgument($index).AddArgument($properties.Name).AddArgument($propertiesHT).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)

                $runspace.RunspacePool = $runspacePool
                $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })

                $index++
            }

            # Collect results
            $total = $runspaces.Count
            $completed = 0

            while ($runspaces.Count -gt 0) {
                for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                    $r = $runspaces[$i]
                    if (-not $r.Status.IsCompleted) { continue }

                    $output = $r.Pipe.EndInvoke($r.Status)
                    $completed++

                    if ($completed % 250 -eq 0 -or $completed -eq $total) {
                        $percent = [math]::Round(($completed / $total) * 100, 2)
                        Log info "Progress: [$completed/$total] requests completed ($percent%)"
                    }

                    if($null -ne $output.logMessage) {
                        Log verbose $output.logMessage
                    }

                    $item = $output.rawResult

                    # CustomData
                    if($item.'urn:ietf:params:scim:schemas:extension:spend:2.0:User'.customData.length -gt 0) {
                        foreach($subItem in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:User'.customData) {
                            [void]$Global:SpendUsers_CustomData.Add([PSCustomObject]@{
                                nim_id = Get-ObjectHash -Object $subItem
                                spendUser_id = $item.id
                                id = $subItem.id
                                value = $subItem.Value
                                syncGuid = $subItem.syncGuid
                                href = $subItem.href
                            })
                        }
                    }

                    # Approver
                    if($item.'urn:ietf:params:scim:schemas:extension:spend:2.0:Approver'.report.length -gt 0) {
                        foreach($subItem in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:Approver'.report) {
                            [void]$Global:SpendUsers_Approver.Add([PSCustomObject]@{
                                nim_id = Get-ObjectHash -Object $subItem
                                spendUser_id = $item.id
                                approver_value = $subItem.approver.value
                                primary = $subItem.primary
                            })
                        }
                    }

                    # Approver Limit
                    foreach($prop in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:ApproverLimit'.PSObject.Properties) {
                        foreach($subItem in $prop.Value) {
                            [void]$Global:SpendUsers_ApproverLimit.Add([PSCustomObject]@{
                                nim_id = Get-ObjectHash -Object $subItem
                                spendUser_id = $item.id
                                type = $prop.Name
                                approvalGroup = $subItem.approvalGroup
                                approvalLimit = $subItem.approvalLimit
                                approvalType = $subItem.approvalType
                                exceptionApprovalAuthority = $subItem.exceptionApprovalAuthority
                                reimbursementCurrency = $subItem.reimbursementCurrency
                            })
                        }
                    }

                    # Delegate
                    foreach($prop in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:Delegate'.PSObject.Properties) {
                        foreach($subItem in $prop.Value) {
                            [void]$Global:SpendUsers_Delegate.Add([PSCustomObject]@{
                                nim_id = Get-ObjectHash -Object $subItem
                                spendUser_id = $item.id
                                type = $prop.Name
                                canApprove = $subItem.canApprove
                                canPrepare = $subItem.canPrepare
                                canPrepareForApproval = $subItem.canPrepareForApproval
                                canReceiveApprovalEmail = $subItem.canReceiveApprovalEmail
                                canReceiveEmail = $subItem.canReceiveEmail
                                canSubmit = $subItem.canSubmit
                                canSubmitTravelRequest = $subItem.canSubmitTravelRequest
                                canUseBi = $subItem.canUseBi
                                canViewReceipt = $subItem.canViewReceipt
                                delegate_value = $subItem.delegate.value
                            })
                        }
                    }

                    # Roles
                    if($item.'urn:ietf:params:scim:schemas:extension:spend:2.0:Role'.roles.length -gt 0) {
                        foreach($subItem in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:Role'.roles) {
                            [void]$Global:SpendUsers_Roles.Add([PSCustomObject]@{
                                nim_id = Get-ObjectHash -Object $subItem
                                spendUser_id = $item.id
                                roleName = $subItem.roleName
                                roleGroups = $subItem.roleGroups
                            })
                        }
                    }

                    [void]$Global:SpendUsers.Add(($output.result | Select-Object $function_params.properties))

                    $r.Pipe.Dispose()
                    $runspaces.RemoveAt($i)
                }
                if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
            }

            $runspacePool.Close()
            $runspacePool.Dispose()
            $cancellationSource.Dispose()
        }

        $Global:SpendUsers
}

function Idm-spend_userCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' -or $_.options -contains 'create_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'create_m' -or $_.options -contains 'create_o' -or $_.options -contains 'optional' -or $_.options.Contains('key') ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.id
        
        $body = [PSObject]@{
            'Operations' = [System.Collections.ArrayList]@()
        }
        
        $lookup = @{}
        $Properties.SpendUser | Where-Object { $null -ne $_.alias} | ForEach-Object { $lookup[$_.alias] = $_.name }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'id') { continue }

            $prefix = $prop.Name.split('_')[0]
            $lookupValue = $lookup[$prefix]

            if($lookupValue.length -gt 0) {
                $fieldname = '{0}:{1}' -f $lookupValue, $prop.Name.replace("$($prefix)_",'')
            } else {
                $fieldname = $prop.Name
            }
            
            [void]$body.Operations.Add([PSObject]@{
                'op' ='replace'
                'path' = $fieldname
                'value' = $prop.Value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "SpendUserCreate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-spend_userUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' -or $_.options -contains 'update_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'update_m' -or $_.options -contains 'update_o' -or $_.options -contains 'optional' -or $_.options.Contains('key') ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.id
        
        $body = [PSObject]@{
            'Operations' = [System.Collections.ArrayList]@()
        }
        
        $lookup = @{}
        $Properties.SpendUser | Where-Object { $null -ne $_.alias} | ForEach-Object { $lookup[$_.alias] = $_.name }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'id') { continue }

            $prefix = $prop.Name.split('_')[0]
            $lookupValue = $lookup[$prefix]

            if($lookupValue.length -gt 0) {
                $fieldname = '{0}:{1}' -f $lookupValue, $prop.Name.replace("$($prefix)_",'')
            } else {
                $fieldname = $prop.Name
            }
            
            [void]$body.Operations.Add([PSObject]@{
                'op' ='replace'
                'path' = $fieldname
                'value' = $prop.Value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "SpendUserUpdate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-spend_users_customDatasRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser_CustomData'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:SpendUsers.Count -eq 0) {
            Idm-spend_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:SpendUsers_CustomData
}

function Idm-spend_users_customDataCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser_CustomData'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'create_m' -or $_.options -contains 'create_o' -or $_.options -contains 'optional' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'replace'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq "{0}"].value' -f $function_params.id
            'value' = $function_params.value
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        $function_params.nim_id = Get-ObjectHash -Object $function_params
        LogIO info "spendUserCustomDataCreate" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-spend_users_customDataUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser_CustomData'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_m' -or $_.options -contains 'key' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'update_m' -or $_.options -contains 'update_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'replace'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq "{0}"].value' -f $function_params.id
            'value' = $function_params.value
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "spendUserCustomDataUpdate" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-spend_users_approverRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser_Approver'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:SpendUsers.Count -eq 0) {
            Idm-spend_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:SpendUsers_Approver
}

function Idm-spend_users_approverLimitRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser_ApproverLimit'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:SpendUsers.Count -eq 0) {
            Idm-spend_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:SpendUsers_ApproverLimit
}
function Idm-spend_users_delegateRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser_Delegate'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:SpendUsers.Count -eq 0) {
            Idm-spend_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:SpendUsers_Delegate
}
function Idm-spend_users_rolesRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'SpendUser_Role'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:SpendUsers.Count -eq 0) {
            Idm-spend_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:SpendUsers_Roles
}

function Idm-spend_users_roleAdd {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser_Role'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'add_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'add_m' -or $_.options -contains 'add_o' -or $_.options -contains 'optional' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'add'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:Role:roles'
            'value' = @(
                [PSObject]@{
                    'roleName' = $function_params.roleName
                }
            )
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        $function_params.nim_id = Get-ObjectHash -Object $function_params
        LogIO info "spendUserRoleAdd" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-spend_users_roleRemove {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'SpendUser_Role'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'delete'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'remove_m' -or $_.options -contains 'key'  } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'remove_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'remove_m' -or $_.options -contains 'remove_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id          
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }

        $newObj = [PSObject]@{
            'op' = 'remove'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:Role:roles[roleName eq "{0}"]' -f $function_params.roleName
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat

        LogIO info "spendUserRoleRemove"
    }
    
    Log verbose "Done"
}

function Idm-travel_usersRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'TravelUser'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if(     $Global:TravelUsers.count -lt 1) {  

            if ($Global:IdentityUsers.Count -eq 0) {
                Idm-identity_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
            }

            # Precompute property template
            $properties = $Global:Properties.$Class | Where-Object { ('hidden' -notin $_.options ) }
            $propertiesHT = @{}; $Global:Properties.$Class | ForEach-Object { $propertiesHT[$_.name] = $_ }
            
            $template = [ordered]@{}
            foreach ($prop in $properties.Name) {

                if($propertiesHT[$prop].Type -eq 'object') {
                    $colPrefix = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                    foreach($path in $propertiesHT[$prop].objectfields) {
                        $template["$($colPrefix)_$($path.Replace('.','_'))"] = $null
                    }
                    continue
                }

                $colName = if ($propertiesHT[$prop].alias) { $propertiesHT[$prop].alias } else { $prop }
                $template[$colName] = $null
            }

            # Prepare runspace pool
            $cancellationSource = [System.Threading.CancellationTokenSource]::new()

            $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
            $runspacePool.Open()
            $runspaces = [System.Collections.Generic.List[PSCustomObject]]::new()

            # Index for tracking
            $index = 0

            $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef3 = "function Initialize-Proxy { $((Get-Command Initialize-Proxy -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef4 = "function Resolve-NestedValue { $((Get-Command Resolve-NestedValue -CommandType Function).ScriptBlock.ToString()) }"

            # Capture once — stable for the entire sync
            $proxySnapshot           = if ($Global:Proxy) { $Global:Proxy.Clone() } else { $null }
            $authTokenSnapshot       = $Global:AuthToken
            $proxyInitializedSnapshot = $Global:ProxyInitialized

            foreach ($item in $Global:IdentityUsers) {
                $runspace = [powershell]::Create()

                [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript($funcDef3).AddScript($funcDef4).AddScript({
                    param($item, $system_params, $Class, $template, $index, $properties, $propertiesHT, $proxy, $authToken, $proxyInitialized)

                    $Global:Proxy            = $proxy
                    $Global:AuthToken        = $authToken
                    $Global:ProxyInitialized = $proxyInitialized

                    $itemResult = @{
                        result = $null
                        logMessage = $null
                        rawResult = $null
                    }

                    $splat = @{
                        SystemParams = $system_params
                        Method = "GET"
                        Uri = "profile/travel/v4/Users/$($item.id)"
                        LoggingEnabled = $false
                    }

                    try {
                        $response = Execute-Request @splat
                    } catch {
                        $itemResult.logMessage = "Retrieve User Info [$($item.id)] - $_"
                        return $itemResult
                    }
                    $response = $response[0]

                    $row = [PSCustomObject]([ordered]@{} + $template)

                    $itemResult.rawResult = $response

                    foreach ($prop in $response.PSObject.Properties) {
                        $schemaProp = $propertiesHT[$prop.Name]
                        if($schemaProp.Type -eq 'object') {
                            $colPrefix = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                            foreach($path in $schemaProp.objectfields) {
                                $row.("$($colPrefix)_$($path.Replace('.','_'))") = Resolve-NestedValue $prop.Value $path
                            }
                            continue
                        }

                        $colName = if ($schemaProp.alias) { $schemaProp.alias } else { $prop.Name }
                        $row.($colName) = $prop.Value
                    }

                    $itemResult.result = $row

                    return $itemResult
                }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($template).AddArgument($index).AddArgument($properties.Name).AddArgument($propertiesHT).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot).AddArgument($proxyInitializedSnapshot)

                $runspace.RunspacePool = $runspacePool
                $runspaces.Add([PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index })
                $index++
            }

            # Collect results
            $total = $runspaces.Count
            $completed = 0

            while ($runspaces.Count -gt 0) {
                for ($i = $runspaces.Count - 1; $i -ge 0; $i--) {
                    $r = $runspaces[$i]
                    if (-not $r.Status.IsCompleted) { continue }

                    $output = $r.Pipe.EndInvoke($r.Status)
                    $completed++

                    if ($completed % 250 -eq 0 -or $completed -eq $total) {
                        $percent = [math]::Round(($completed / $total) * 100, 2)
                        Log info "Progress: [$completed/$total] requests completed ($percent%)"
                    }

                    if($null -ne $output.logMessage) {
                        Log verbose $output.logMessage
                    }

                    # Custom Fields
                    foreach($subItem in $output.rawResult.'urn:ietf:params:scim:schemas:extension:travel:2.0:User'.customFields) {
                        [void]$Global:TravelUsers_CustomFields.Add([PSCustomObject]@{
                            travelUser_id = $output.rawResult.id
                            name = $subItem.name
                            value = $subItem.Value
                        })
                    }

                    [void]$Global:TravelUsers.Add(($output.result | Select-Object $function_params.properties))

                    $r.Pipe.Dispose()
                    $runspaces.RemoveAt($i)
                }
                if ($runspaces.Count -gt 0) { Start-Sleep -Milliseconds 2500 }
            }

            $runspacePool.Close()
            $runspacePool.Dispose()
            $cancellationSource.Dispose()
        }

        $Global:TravelUsers
}

function Idm-travel_userCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'TravelUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' -or $_.options -contains 'create_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'create_m' -or $_.options -contains 'create_o' -or $_.options -contains 'optional' -or $_.options.Contains('key') ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.id
        
        $body = [PSObject]@{
            'Operations' = [System.Collections.ArrayList]@()
        }
        
        $lookup = @{}
        $Properties.TravelUser | Where-Object { $null -ne $_.alias} | ForEach-Object { $lookup[$_.alias] = $_.name }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'id') { continue }

            $prefix = $prop.Name.split('_')[0]
            $lookupValue = $lookup[$prefix]

            if($lookupValue.length -gt 0) {
                $fieldname = '{0}:{1}' -f $lookupValue, $prop.Name.replace("$($prefix)_",'')
            } else {
                $fieldname = $prop.Name
            }
            
            [void]$body.Operations.Add([PSObject]@{
                'op' ='replace'
                'path' = $fieldname
                'value' = $prop.Value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "TravelUserCreate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-travel_userUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'TravelUser'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'key' -or $_.options -contains 'update_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'update_m' -or $_.options -contains 'update_o' -or $_.options -contains 'optional' -or $_.options.Contains('key') ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.id
        
        $body = [PSObject]@{
            'Operations' = [System.Collections.ArrayList]@()
        }
        
        $lookup = @{}
        $Properties.TravelUser | Where-Object { $null -ne $_.alias} | ForEach-Object { $lookup[$_.alias] = $_.name }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name -eq 'id') { continue }

            $prefix = $prop.Name.split('_')[0]
            $lookupValue = $lookup[$prefix]

            if($lookupValue.length -gt 0) {
                $fieldname = '{0}:{1}' -f $lookupValue, $prop.Name.replace("$($prefix)_",'')
            } else {
                $fieldname = $prop.Name
            }
            
            [void]$body.Operations.Add([PSObject]@{
                'op' ='replace'
                'path' = $fieldname
                'value' = $prop.Value
            })
        }

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "TravelUserUpdate" -out $response
        $function_params
        
    }

    Log verbose "Done"
}

function Idm-travel_users_customFieldsRead {
    param (
        # Mode
        [switch] $GetMeta,    
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams

    )
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams
        $Class = 'TravelUser_CustomField'
        
        if ($GetMeta) {
            Get-ClassMetaData -SystemParams $SystemParams -Class $Class
            return
        }

        # Refresh cache if needed
        if ($Global:TravelUsers.Count -eq 0) {
            Idm-travel_usersRead -SystemParams $SystemParams -FunctionParams $FunctionParams | Out-Null
        }

        $Global:TravelUsers_CustomFields
}

function Idm-travel_users_customFieldCreate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'TravelUser_CustomField'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'create'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'create_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'create_m' -or $_.options -contains 'create_o' -or $_.options -contains 'optional' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'replace'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq "{0}"].value' -f $function_params.id
            'value' = $function_params.value
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        $function_params.nim_id = Get-ObjectHash -Object $function_params
        LogIO info "spendUserCustomDataCreate" -out $function_params
    }
    
    Log verbose "Done"
}

function Idm-travel_users_customFieldUpdate {
    param (
        # Operations
        [switch] $GetMeta,
        # Parameters
        [string] $SystemParams,
        [string] $FunctionParams
    )

    Log verbose "-GetMeta=$GetMeta -SystemParams='$SystemParams' -FunctionParams='$FunctionParams'"
    $Class = 'TravelUser_CustomField'

    if ($GetMeta) {
        #
        # Get meta data
        #
        @{
            semantics = 'update'
            parameters = @(
                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_m' -or $_.options -contains 'key' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'update_o' -or $_.options -contains 'optional' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field.replace('.','_'))"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'update_m' -or $_.options -contains 'update_o' -or $_.options -contains 'optional' -or $_.options -contains 'key' ) } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'prohibited' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'prohibited' }
                        }
                    }
            )
        }
    }
    else {
        #
        # Execute function
        #
        $system_params   = ConvertFrom-Json2 $SystemParams
        $function_params = ConvertFrom-Json2 $FunctionParams

        $uri = "profile/v4/Users/{0}" -f $function_params.spendUser_id
        
        $body = [PSObject]@{
            "schemas" = @("urn:ietf:params:scim:api:messages:2.0:PatchOp")
            "Operations"= [System.Collections.ArrayList]@()
        }
        $newObj = [PSObject]@{
            'op' = 'replace'
            'path' = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User:customData[id eq "{0}"].value' -f $function_params.id
            'value' = $function_params.value
        }
        
        [void]$body.Operations.Add($newObj)

        $splat = @{
            SystemParams = $system_params
            Method = "PATCH"
            Uri = $uri                    
            Body = ($body | ConvertTo-Json -Depth 10)
        }
        
        $response = Execute-Request @splat
    
        LogIO info "spendUserCustomDataUpdate" -out $function_params
    }
    
    Log verbose "Done"
}

#
#   Internal Functions
#
function Initialize-Proxy {
    param (
        [hashtable] $SystemParams
    )

    if($SystemParams.use_proxy)
                {
                    Add-Type @"
using System.Net;
using System.Security.Cryptography.X509Certificates;
public class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
        return true;
    }
}
"@
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
                    
        $Global:Proxy['ProxyAddress'] = $SystemParams.proxy_address

        if($SystemParams.use_proxy_credentials)
        {
            $Global:Proxy["ProxyCredential"] = New-Object System.Management.Automation.PSCredential ($SystemParams.proxy_username, (ConvertTo-SecureString $SystemParams.proxy_password -AsPlainText -Force) )
        }
    } else {
        $Global:Proxy = $null
    }


}

function Execute-Authorization {
    param (
        [hashtable] $SystemParams
    )

        $splat = @{
            Headers = @{
                "Accept" = "application/json"
            }
            body = @{
                grant_type     = "refresh_token"
                client_id      = $SystemParams.client_id
                client_secret  = $SystemParams.client_secret
                refresh_token  = $SystemParams.refresh_token
            }
            Method = 'POST'
            Uri = ("https://{0}/{1}" -f $SystemParams.geolocation, "oauth2/v0/token")
            ContentType = "application/x-www-form-urlencoded"
        }

        if($SystemParams.use_proxy) {
            $splat["Proxy"] = $Global:Proxy['ProxyAddress']
            if($SystemParams.use_proxy_credentials) {
                $splat["proxyCredential"] = $Global:Proxy["ProxyCredential"]
            }
        }

        $Global:AuthToken = (Invoke-RestMethod @splat).access_token
}

function Execute-Request {
    param (
        [hashtable] $SystemParams,
        [string] $Method,
        [object] $Body,
        [string] $Uri,
        [string] $Path = $null,
        [boolean] $LoggingEnabled = $true,
        [boolean] $BypassPagination = $false
    )

    if (-not $Global:ProxyInitialized) {
        Initialize-Proxy -SystemParams $SystemParams
        $Global:ProxyInitialized = $true
    }

    if ($Global:AuthToken.length -lt 1) {
        Execute-Authorization $SystemParams
    }

    # Build base request
    $splat = @{
        Headers = @{
            "Authorization" = ("Bearer {0}" -f $Global:AuthToken)
            "Accept"        = "application/json"
            "Content-Type"  = "application/json"
        }
        Method = $Method
        Uri    = ("https://{0}/{1}" -f $SystemParams.geolocation, $Uri)
    }
 
    if ($Body) {
        $splat.Body = $Body
    }

    if ($SystemParams.use_proxy) {
        $splat["Proxy"] = $Global:Proxy['ProxyAddress']
        if ($SystemParams.use_proxy_credentials) {
            $splat["ProxyCredential"] = $Global:Proxy["ProxyCredential"]
        }
    }

    # Convert Body → query parameters for GET requests
    if ($Method -eq "GET" -and $Body) {

        # Ensure Body is a hashtable before treating it as query params
        if ($Body -is [hashtable]) {

            $queryString = (
                $Body.GetEnumerator() |
                ForEach-Object { "$($_.Key)=$([Uri]::EscapeDataString($_.Value))" }
            ) -join "&"

            if ($queryString.Length -gt 0) {
                if ($splat.Uri -notmatch "\?") {
                    $splat.Uri = "$($splat.Uri)?$queryString"
                }
                else {
                    $splat.Uri = "$($splat.Uri)&$queryString"
                }
            }
        }

        # GET requests cannot send a body
        if ($splat.ContainsKey("Body")) {
            $splat.Remove("Body")
        }
    }

    # Cursor pagination accumulator
    $allData = [System.Collections.Generic.List[object]]::new()
    $baseUri = $splat.Uri
    $cursor = $null

    do {
        # Add cursor to query string if present
        if ($cursor) {
            $splat.Uri = if ($baseUri -match '\?') { "$($baseUri)&cursor=$cursor" } else { "$($baseUri)?cursor=$cursor" }
        }

        $attempt = 0
        $retryDelay = $SystemParams.retryDelay

        do {
            try {
                $attemptSuffix = if ($attempt -gt 0) { " (Attempt $($attempt + 1))" } else { "" }
                if($LoggingEnabled) { Log verbose "$($splat.Method) Call: $($splat.Uri)$attemptSuffix" }

                $response = Invoke-RestMethod @splat -ErrorAction Stop
                break
            }
            catch {
                $statusCode = $_.Exception.Response.StatusCode.value__

                switch ($statusCode) {

                    403 {
                        if($LoggingEnabled) { Log warning "Received 403 Forbidden. Attempting reauthentication..." }

                        # Re-authenticate
                        Execute-Authorization $SystemParams

                        # Update Authorization header with new token
                        $splat.Headers["Authorization"] = ("Bearer {0}" -f $Global:AuthToken)

                        # Retry once immediately
                        try {
                            $response = Invoke-RestMethod @splat -ErrorAction Stop
                            break
                        }
                        catch {
                            throw "403 persisted after reauthentication. Aborting request."
                        }
                    }

                    429 {
                        $attempt++
                        if ($attempt -ge $SystemParams.nr_of_retries) {
                            throw "Max retry attempts reached for $Uri"
                        }
                        if($LoggingEnabled) { Log warning "Received 429. Retrying in $retryDelay seconds..." }
                        Start-Sleep -Seconds $retryDelay
                        $retryDelay *= 2
                    }

                    default {
                        throw
                    }
                }
            }
        } while ($true)

        # Append data
        if ($Path.length -lt 1) {
            $allData.Add($response)
        } else {
            if ($response.$Path) {
                $allData.AddRange([object[]]@($response.$Path))
            }
        }

        # Get next cursor
        if($BypassPagination) { break }
        $cursor = $response.nextCursor

    } while ($cursor)

    return $allData
}

function Resolve-NestedValue {
    param($obj, [string]$path)
    $current = $obj
    foreach ($segment in $path.Split('.')) {
        if ($null -eq $current) { return $null }
        $current = $current.$segment
    }
    return $current
}

function Get-ClassMetaData {
    param (
        [string] $SystemParams,
        [string] $Class
    )

    @(
        @{
            name = 'properties'
            type = 'grid'
            label = 'Properties'
            table = @{
                rows = @( $Global:Properties.$Class | ForEach-Object {
                    $prop = $_
                    $usageHint = @( @(
                        foreach ($opt in $prop.options) {
                            if ($opt -notin @('default', 'idm', 'key')) { continue }
                            if ($opt -eq 'idm') { $opt.ToUpper() }
                            else { $opt.Substring(0,1).ToUpper() + $opt.Substring(1) }
                        }
                    ) | Sort-Object) -join ' | '

                    if ($prop.type -eq 'object' -and $prop.objectfields) {
                        $colPrefix = if ($prop.alias) { $prop.alias } else { $prop.name }
                        foreach ($path in $prop.objectfields) {
                            @{
                                name = "$($colPrefix)_$($path.Replace('.','_'))"
                                usage_hint = $usageHint
                            }
                        }
                    } else {
                        @{
                            name = if ($prop.alias) { $prop.alias } else { $prop.name }
                            usage_hint = $usageHint
                        }
                    }
                })
                settings_grid = @{
                    selection = 'multiple'
                    key_column = 'name'
                    checkbox = $true
                    filter = $true
                    columns = @(
                        @{
                            name = 'name'
                            display_name = 'Name'
                        }
                        @{
                            name = 'usage_hint'
                            display_name = 'Usage hint'
                        }
                    )
                }
            }
            value = @( $Global:Properties.$Class | Where-Object { $_.options.Contains('default') } | ForEach-Object {
                if ($_.type -eq 'object' -and $_.objectfields) {
                    $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                    foreach ($path in $_.objectfields) { "$($colPrefix)_$($path.Replace('.','_'))" }
                } else {
                    if ($_.alias) { $_.alias } else { $_.name }
                }
            })
        }
    )
}

function Get-ObjectHash {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $Object,

        [ValidateSet("SHA256","SHA1","SHA384","SHA512","MD5")]
        [string]$Algorithm = "SHA256",

        [ValidateSet("Base64","Hex")]
        [string]$Encoding = "Base64"
    )

    # Convert object → JSON → UTF8 bytes
    $json  = $Object | ConvertTo-Json -Depth 10
    $bytes = [Text.Encoding]::UTF8.GetBytes($json)

    # Compute hash
    $hasher = [Security.Cryptography.HashAlgorithm]::Create($Algorithm)
    try {
        $hashBytes = $hasher.ComputeHash($bytes)
    } finally {
        $hasher.Dispose()
    }

    # Output format
    switch ($Encoding) {
        "Base64" { return [Convert]::ToBase64String($hashBytes) }
        "Hex"    { return -join ($hashBytes | ForEach-Object { $_.ToString("x2") }) }
    }
}

function Get-ProvisioningStatus {
    param (
    [hashtable] $SystemParams,    
    [object] $ProvisionStatus
    )
        # Poll bulk provisioning status until complete or max wait
        if ($null -ne $ProvisionStatus.meta.location) {
            $provisionUri = ([Uri]$ProvisionStatus.meta.location).PathAndQuery.TrimStart('/')
            $maxAttempts  = 30
            $pollInterval = [int]$SystemParams.retryDelay

            for ($attempt = 1; $attempt -le $maxAttempts; $attempt++) {
                if ($attempt -gt 1) { Start-Sleep -Seconds $pollInterval }

                $statusSplat = @{
                    SystemParams = $SystemParams
                    Method       = "GET"
                    Uri          = $provisionUri
                    Body         = @{ attributes = "operations" }
                }
                $ProvisionStatus = (Execute-Request @statusSplat)[0]

                if ($ProvisionStatus.status.completed -eq $true) { break }
            }

            if (-not $ProvisionStatus.status.completed) {
                Log warning "Bulk provision did not complete after $maxAttempts attempts ($($maxAttempts * $pollInterval)s max wait)"
            }
        }

        if($ProvisionStatus.operationsCount.failed -gt 0) {
            foreach($item in $ProvisionStatus.operations.extensions) {
                if($item.status.success -eq $false -and $item.status.success -ne $null) {
                    foreach($message in $item.messages) {
                        log error "$($message | ConvertTo-Json)"
                    }
                }
            }
            throw "Failed request"
        }
}

$configScenarios = @'
[{"name":"Default Configuration","description":"","version":"1.0","createTime":1777063702449,"modify
Time":1777063702449,"name_values":[{"name":"access_token","value":{"type":"crypto_aes","data":"ty3Bl
U0jWL8gqxC23/xlgpkPsuKpnBLkuVsZfL77IsToyxVYpchk1pTxhNs5LNaMo/tfCtiqxb9f2ws4mIKCMV02Fd7w0WA0cg3KqClqf
RiNI6yYOfwMnB6NuCWODFh0xcqXB+qQ1HYRHvRmGB3WuPfRnGpeWGOMYsLYw+5mB8/9vhhq0T6HEWMNJ9DRu8zTXcU21QZgRPPrO
Aq7HGv6Z0gkFvVmL/kUhF/ZTRp8Q2A6OI0qIQsQ1LFLb9YDeIjNTzBrC5JDo6bGSf6V9WgZj3vKvSa9eOir35e11p//AdqXy38NS
yGOJxMVkHAAqqp+i/wnHoXE/WMYugdCeF1bKTzs8j8VvZxFP2jj0gU/Y3jmyYRgkT5GwNmmGk6ghkYDZYAfkz7ugUHvUfAhVx6Qp
VGtA9eGx4NVX7FJMHeNE/6c0a1XSHy4zpnCR/BWlPQePljhmvPpjHSz+Ci0tiyU+VeJwEug17j1gPXD7a5M2mK9+uwZrZwA045rr
TIsxuow2kplHp6yWPo3Y3Cmf/1mPlDDDciLUntmlMLRpeQS7y5tNdXxXwyPUpd8mkxDMHwVr8cAOjVJaVxETHsp7UN09xJFVMgeV
vXq7ghImenbhxP8X3MnkCyy8upxVObqPnGEw+wMM/rKbMePqTcS4I/iqCF0Jhlmbhl2V2qX+5m2m8N7FqP1Aks8NXk83fWLJtWJD
If7puW2fzIA1RaDI9tSi4i9C6FRRr5QbObSSsRMVEI2CMb8BS4SFs8QoRIa/aTRdgySyQN28HDs+p5VAlhGxaVxQ2bK0vBBvZyzF
kSXnvQevxH+Cj4naz83auDeqrYorwuH3tBWD2vZShKAvoFIRPl9ogI4jDGFUrah/1hl2FEQuWxdfs3q1X1Ah81z5X2jDYHafKovZ
+5Ayy9RNCZ207MCv8UOHCi3O/l9rW2cLSSTqbqSLvZJBTxNrOwSD9vliARWFEtnBsIIxINBdMw8v0Pk78mzibGBJ+kr3+UuyaMda
qTnj39v9YjOFtZyF9/GtyHpVBuUQhixFZplc3UmhYHXNOWyF2/ih8kxkMQu3+rEfjziqISWCjoN49eXMPq0FpdRzJ7LIFS4xsszF
hEAnTMV1xdwBZTvSlPm5FEysamn5DMeieEqPHNyXEHmnqwfkmsfAwr9llT6FKwPocYq2d0UuRDzSf741q26muKjcnUqdtR8v9mNb
MWRi7kNx7rFnKIHnfqIC26rqzQQopSabShfQgJ0Gf2G9AWRjA8vPuz66XFoRv0z06T1Qv1MgSRhqrfXtIds/E7kX0ADvCUxCjfzJ
t5tOoFSXxsd1vJctQ6fscSGJk7LO4gnwYCXMYd98UPVezLNRaeTvxOsO+yImbXaWKIuUTN/3jm5PGrTqH3rAoDhKmCixlO0plv1C
J+0Lfk7YjZgUFXUSQSaXK+nKK4H1AwM3Hgcxf3WCnKWpNww2oQYPlnjeKw/sghvc42Nkulx5Fi024fqk2+/XW6CrSzJpdJA6EQar
pchhnxQkEsldWHFvKxjU0FWVlEpEfwc7L77dkHCpjF58JuTYtwXXwKtUYm3wLpmNY7RlHYjeuvd69k8mpq9YY1VxD9WAZLI74tSj
0nJEiK7Pc42reb2YcySJnFvy9ozOoSx6obWHfyWcloZXj5bGSiqZqSWuA3YsQMKJY0203hegrqMD6f5xl9D+rb8cCyDhiwVCbjCB
seSKTLVuurDs0C0Pe2pGooVOtYjwGEpwaPjWZ3i764nGydf44yDUoXr4NyTNKyDeCxe8BVpCUIuFdepq6EEyp6iglg/XlXu29HRO
LgEnoogKY7AEWUF3eHk02KCcT+8gXUCOI+/dWY0ms/x9DikhBLhD8K86KR2WA3xRZTM4xhcZAnVwBTfmwZ3gLJhZcBcuvtCl7F0q
Or8e4+UAu3ctONhqV6dSjOP2OIVCcHuU2pqtquxrAJtCv0BzUNCNxPjzfi8ZeVG5JWgND9ce7qcclHkbxYvagFTDOPhSjmLkTE+2
TYhNPcmaMwYcYhWGyLArSfE3oTrbQ8oECMq2aO2DbIh6buJvmNd33/WrTGzfW8fYRKlRHf8iulIHKaXuQdRZO/nK1hJPfG57NpHx
HVQdXiPiYJ4UFh4CCHQd0nEcxI1uAts7Z2e2zs8XtKD1iY4RReceHwFrS5mDX5qElPgv+VE90VSof1XlgOetHi2j1t6ssGvMQDEj
f/tQRmkwhpBNDUOTcM7PZYj6nYeKbqK0XA2Cpnmpyxu58i5SHj2ATRB150neUZ+C6pl6Vm47pUKSb5+vGnrIsa1Vn7ndvpLe7ree
aDz4w90qVvrLlAGNBC1QW4FPII6//J6WTCQUj8SL950licKA6wrpiZJfGGqfT0/IhZhiIdTk3FxglS+AOLSiMXy1BGoGtSveZe9F
6P7e3YcQkUKF7p/nxWJMxiLW1DwwYfBsFQ=","tag":"pGO8w8l0TUDXK/ZkzwGVoA=="}},{"name":"client_id","value":
null},{"name":"client_secret","value":null},{"name":"collections","value":["formFields","identity_us
ers_addresses","identity_users_emails","identity_users_emergencyContacts","identity_users_phoneNumbe
rs","identity_users","roles","spend_users_approverLimit","spend_users_approver","spend_users_customD
atas","spend_users_delegate","spend_users_roles","spend_users","spendCategoryCodes","travel_users_cu
stomFields","travel_users"]},{"name":"company_request_token","value":null},{"name":"company_uuid","v
alue":null},{"name":"geolocation","value":null},{"name":"nr_of_retries","value":null},{"name":"nr_of
_sessions","value":null},{"name":"nr_of_threads","value":null},{"name":"proxy_address","value":null}
,{"name":"proxy_password","value":null},{"name":"proxy_username","value":null},{"name":"refresh_toke
n","value":null},{"name":"retryDelay","value":null},{"name":"sessions_idle_timeout","value":null},{"
name":"use_proxy","value":null},{"name":"use_proxy_credentials","value":null}],"collections":[{"col_
name":"formFields","fields":[{"field_name":"id","field_type":"string","include":true,"field_format":
"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field
_name":"access","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"controlType","field_type
":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refe
rence":false,"ref_col_fields":[]},{"field_name":"dataType","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"isCustom","field_type":"boolean","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"isRequired
","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref
_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"label","field_type":"string","include
":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_c
ol_fields":[]},{"field_name":"maxLength","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"name","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"",
"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"schemas","field_type":"string-arr
ay","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":
false,"ref_col_fields":[]},{"field_name":"sequence","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"k
ey":"id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"iden
tity_users_addresses","fields":[{"field_name":"nim_id","field_type":"string","include":true,"field_f
ormat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},
{"field_name":"identityuser_id","field_type":"string","include":true,"field_format":"","field_source
":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref_col_fields":[]},{"field
_name":"country","field_type":"string","include":true,"field_format":"","field_source":"data","javas
cript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"streetAddress","field_t
ype":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"r
eference":false,"ref_col_fields":[]},{"field_name":"postalCode","field_type":"string","include":true
,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fie
lds":[]},{"field_name":"locality","field_type":"string","include":true,"field_format":"","field_sour
ce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"type",
"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_co
l":[],"reference":false,"ref_col_fields":[]},{"field_name":"region","field_type":"string","include":
true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col
_fields":[]}],"key":"nim_id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data
"},{"col_name":"identity_users_emails","fields":[{"field_name":"nim_id","field_type":"string","inclu
de":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref
_col_fields":[]},{"field_name":"identityuser_id","field_type":"string","include":true,"field_format"
:"","field_source":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref_col_fi
elds":[]},{"field_name":"verified","field_type":"boolean","include":true,"field_format":"","field_so
urce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"type
","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_
col":[],"reference":false,"ref_col_fields":[]},{"field_name":"value","field_type":"string","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"notifications","field_type":"boolean","include":true,"field_format":"",
"field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"ni
m_id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"identit
y_users_emergencyContacts","fields":[{"field_name":"nim_id","field_type":"string","include":true,"fi
eld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields"
:[]},{"field_name":"identityuser_id","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref_col_fields":[]},{"
field_name":"country","field_type":"string","include":true,"field_format":"","field_source":"data","
javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"streetAddress","fi
eld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":
[],"reference":false,"ref_col_fields":[]},{"field_name":"postalCode","field_type":"string","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"name","field_type":"string","include":true,"field_format":"","field_sou
rce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"local
ity","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","r
ef_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"phones","field_type":"string-array"
,"include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fal
se,"ref_col_fields":[]},{"field_name":"region","field_type":"string","include":true,"field_format":"
","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_
name":"relationship","field_type":"string","include":true,"field_format":"","field_source":"data","j
avascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"nim_id","display":"","name
_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"identity_users_phoneNumbers","f
ields":[{"field_name":"nim_id","field_type":"string","include":true,"field_format":"","field_source"
:"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"identityu
ser_id","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":""
,"ref_col":["identity_users"],"reference":false,"ref_col_fields":[]},{"field_name":"issuingCountry",
"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_co
l":[],"reference":false,"ref_col_fields":[]},{"field_name":"display","field_type":"string","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"type","field_type":"string","include":true,"field_format":"","field_sou
rce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"value
","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_
col":[],"reference":false,"ref_col_fields":[]},{"field_name":"notifications","field_type":"boolean",
"include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fals
e,"ref_col_fields":[]},{"field_name":"primary","field_type":"boolean","include":true,"field_format":
"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":
"nim_id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"iden
tity_users","fields":[{"field_name":"id","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"active","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":
"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"addresses","field_type":"strin
g","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":f
alse,"ref_col_fields":[]},{"field_name":"dateOfBirth","field_type":"string","include":true,"field_fo
rmat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{
"field_name":"displayName","field_type":"string","include":true,"field_format":"","field_source":"da
ta","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"emails","fiel
d_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[]
,"reference":false,"ref_col_fields":[]},{"field_name":"emergencyContacts","field_type":"string","inc
lude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"r
ef_col_fields":[]},{"field_name":"entitlements","field_type":"string-array","include":true,"field_fo
rmat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{
"field_name":"externalId","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"localeOverride
s_preferenceEndDayViewHour","field_type":"string","include":true,"field_format":"","field_source":"d
ata","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"localeOverri
des_preferenceFirstDayOfWeek","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"localeOver
rides_preferenceDateFormat","field_type":"string","include":true,"field_format":"","field_source":"d
ata","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"localeOverri
des_preferenceCurrencySymbolLocation","field_type":"string","include":true,"field_format":"","field_
source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"lo
caleOverrides_preferenceHourMinuteSeparator","field_type":"string","include":true,"field_format":"",
"field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_na
me":"localeOverrides_preferenceDistance","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"localeOverrides_preferenceDefaultCalView","field_type":"string","include":true,"field_format":"","f
ield_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name
":"localeOverrides_preference24Hour","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"loc
aleOverrides_preferenceNumberFormat","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"loc
aleOverrides_preferenceStartDayViewHour","field_type":"string","include":true,"field_format":"","fie
ld_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":
"localeOverrides_preferenceNegativeCurrencyFormat","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"localeOverrides_preferenceNegativeNumberFormat","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"meta_resourceType","field_type":"string","include":true,"field_format":"","field_
source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"me
ta_created","field_type":"string","include":true,"field_format":"","field_source":"data","javascript
":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"meta_lastModified","field_ty
pe":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"re
ference":false,"ref_col_fields":[]},{"field_name":"meta_version","field_type":"string","include":tru
e,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fi
elds":[]},{"field_name":"meta_location","field_type":"string","include":true,"field_format":"","fiel
d_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"
name_honorificSuffix","field_type":"string","include":true,"field_format":"","field_source":"data","
javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_formatted","f
ield_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col"
:[],"reference":false,"ref_col_fields":[]},{"field_name":"name_familyName","field_type":"string","in
clude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"
ref_col_fields":[]},{"field_name":"name_givenName","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"name_familyNamePrefix","field_type":"string","include":true,"field_format":"","field_sour
ce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_h
onorificPrefix","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"name_middleName","field_
type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"
reference":false,"ref_col_fields":[]},{"field_name":"nickname","field_type":"string","include":true,
"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fiel
ds":[]},{"field_name":"phoneNumbers","field_type":"string","include":true,"field_format":"","field_s
ource":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"pre
ferredLanguage","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"timezone","field_type":"
string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referen
ce":false,"ref_col_fields":[]},{"field_name":"title","field_type":"string","include":true,"field_for
mat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"
field_name":"EnterpriseUser_terminationDate","field_type":"string","include":true,"field_format":"",
"field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_na
me":"EnterpriseUser_companyId","field_type":"string","include":true,"field_format":"","field_source"
:"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"Enterpris
eUser_department","field_type":"string","include":true,"field_format":"","field_source":"data","java
script":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_organiz
ation","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"",
"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_manager_value","fi
eld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":
[],"reference":false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_manager_employeeNumber","fie
ld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[
],"reference":false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_costCenter","field_type":"str
ing","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference"
:false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_startDate","field_type":"string","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"EnterpriseUser_leavesOfAbsence","field_type":"string","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]},{"field_name":"EnterpriseUser_employeeNumber","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"f
ield_name":"username","field_type":"string","include":true,"field_format":"","field_source":"data","
javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"userName","field_t
ype":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"r
eference":false,"ref_col_fields":[]},{"field_name":"EnterpriseUser_division","field_type":"string","
include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false
,"ref_col_fields":[]}],"key":"id","display":"","name_values":[{"name":"properties","value":["id","ac
tive","addresses","dateOfBirth","displayName","emails","emergencyContacts","entitlements","externalI
d","localeOverrides_preferenceEndDayViewHour","localeOverrides_preferenceFirstDayOfWeek","localeOver
rides_preferenceDateFormat","localeOverrides_preferenceCurrencySymbolLocation","localeOverrides_pref
erenceHourMinuteSeparator","localeOverrides_preferenceDistance","localeOverrides_preferenceDefaultCa
lView","localeOverrides_preference24Hour","localeOverrides_preferenceNumberFormat","localeOverrides_
preferenceStartDayViewHour","localeOverrides_preferenceNegativeCurrencyFormat","localeOverrides_pref
erenceNegativeNumberFormat","meta_resourceType","meta_created","meta_lastModified","meta_version","m
eta_location","name_honorificSuffix","name_formatted","name_familyName","name_givenName","name_famil
yNamePrefix","name_honorificPrefix","name_middleName","nickname","phoneNumbers","preferredLanguage",
"timezone","title","EnterpriseUser_terminationDate","EnterpriseUser_companyId","EnterpriseUser_depar
tment","EnterpriseUser_organization","EnterpriseUser_manager_value","EnterpriseUser_manager_employee
Number","EnterpriseUser_costCenter","EnterpriseUser_startDate","EnterpriseUser_leavesOfAbsence","Ent
erpriseUser_employeeNumber","EnterpriseUser_division","userName"]}],"sys_nn":[],"container":"","sour
ce":"data"},{"col_name":"roles","fields":[{"field_name":"roleCode","field_type":"string","include":t
rue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_
fields":[]},{"field_name":"type","field_type":"string","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"roleFul
lName","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"",
"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"description","field_type":"string
","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fa
lse,"ref_col_fields":[]},{"field_name":"groupAware","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"f
ield_name":"isProductArea","field_type":"string","include":true,"field_format":"","field_source":"da
ta","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"productAreas"
,"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_c
ol":[],"reference":false,"ref_col_fields":[]}],"key":"roleCode","display":"roleFullName","name_value
s":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"spend_users_approverLimit","fields":[
{"field_name":"nim_id","field_type":"string","include":true,"field_format":"","field_source":"data",
"javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"spendUser_id","fi
eld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":
["spend_users"],"reference":false,"ref_col_fields":[]},{"field_name":"type","field_type":"string","i
nclude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,
"ref_col_fields":[]},{"field_name":"approvalGroup","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"approvalLimit","field_type":"string","include":true,"field_format":"","field_source":"dat
a","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"approvalType",
"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_co
l":[],"reference":false,"ref_col_fields":[]},{"field_name":"exceptionApprovalAuthority","field_type"
:"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refe
rence":false,"ref_col_fields":[]},{"field_name":"reimbursementCurrency","field_type":"string","inclu
de":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref
_col_fields":[]}],"key":"nim_id","display":"","name_values":[],"sys_nn":[],"container":"","source":"
data"},{"col_name":"spend_users_approver","fields":[{"field_name":"nim_id","field_type":"string","in
clude":true,"field_format":"","field_source":"data","javascript":"","ref_col":["spend_users"],"refer
ence":false,"ref_col_fields":[]},{"field_name":"spendUser_id","field_type":"string","include":true,"
field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_field
s":[]},{"field_name":"approver_value","field_type":"string","include":true,"field_format":"","field_
source":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref_col_fields":[]},{
"field_name":"primary","field_type":"string","include":true,"field_format":"","field_source":"data",
"javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"nim_id","display":"","na
me_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"spend_users_customDatas","fie
lds":[{"field_name":"nim_id","field_type":"string","include":true,"field_format":"","field_source":"
data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"spendUser_i
d","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref
_col":["spend_users"],"reference":false,"ref_col_fields":[]},{"field_name":"id","field_type":"string
","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fa
lse,"ref_col_fields":[]},{"field_name":"value","field_type":"string","include":true,"field_format":"
","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_
name":"syncGuid","field_type":"string","include":true,"field_format":"","field_source":"data","javas
cript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"href","field_type":"str
ing","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference"
:false,"ref_col_fields":[]}],"key":"nim_id","display":"","name_values":[],"sys_nn":[],"container":""
,"source":"data"},{"col_name":"spend_users_delegate","fields":[{"field_name":"nim_id","field_type":"
string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referen
ce":false,"ref_col_fields":[]},{"field_name":"spendUser_id","field_type":"string","include":true,"fi
eld_format":"","field_source":"data","javascript":"","ref_col":["spend_users"],"reference":false,"re
f_col_fields":[]},{"field_name":"type","field_type":"string","include":true,"field_format":"","field
_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"c
anApprove","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript
":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"canPrepare","field_type":"bo
olean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referenc
e":false,"ref_col_fields":[]},{"field_name":"canPrepareForApproval","field_type":"boolean","include"
:true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_co
l_fields":[]},{"field_name":"canReceiveApprovalEmail","field_type":"boolean","include":true,"field_f
ormat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},
{"field_name":"canReceiveEmail","field_type":"boolean","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"canSubm
it","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","r
ef_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"canSubmitTravelRequest","field_type
":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"ref
erence":false,"ref_col_fields":[]},{"field_name":"canUseBi","field_type":"boolean","include":true,"f
ield_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields
":[]},{"field_name":"canViewReceipt","field_type":"boolean","include":true,"field_format":"","field_
source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"de
legate_value","field_type":"string","include":true,"field_format":"","field_source":"data","javascri
pt":"","ref_col":["identity_users"],"reference":false,"ref_col_fields":[]}],"key":"nim_id","display"
:"","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"spend_users_roles","fi
elds":[{"field_name":"nim_id","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"spendUser_
id","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","re
f_col":["spend_users"],"reference":false,"ref_col_fields":[]},{"field_name":"roleName","field_type":
"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":["roles"],
"reference":false,"ref_col_fields":[]},{"field_name":"roleGroups","field_type":"string","include":tr
ue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_f
ields":[]}],"display":"roleName","name_values":[],"sys_nn":[{"field_a":"spendUser_id","col_a":"spend
_users","field_b":"roleName","col_b":"roles"}],"container":"roleName","source":"data"},{"col_name":"
spend_users","fields":[{"field_name":"id","field_type":"string","include":true,"field_format":"","fi
eld_source":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref_col_fields":[
]},{"field_name":"schemas","field_type":"string","include":true,"field_format":"","field_source":"da
ta","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"meta_resource
Type","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","
ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"meta_created","field_type":"string
","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fa
lse,"ref_col_fields":[]},{"field_name":"meta_lastModified","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"meta_version","field_type":"string","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"meta_lo
cation","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":""
,"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser_reimbursementCurrency"
,"field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_c
ol":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser_reimbursementType","field_typ
e":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"ref
erence":false,"ref_col_fields":[]},{"field_name":"SpendUser_ledgerCode","field_type":"string","inclu
de":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref
_col_fields":[]},{"field_name":"SpendUser_country","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"SpendUser_budgetCountryCode","field_type":"string","include":true,"field_format":"","fiel
d_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"
SpendUser_stateProvince","field_type":"string","include":true,"field_format":"","field_source":"data
","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser_local
e","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref
_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser_cashAdvanceAccountCode","fi
eld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":
[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser_testEmployee","field_type":"strin
g","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":f
alse,"ref_col_fields":[]},{"field_name":"SpendUser_nonEmployee","field_type":"string","include":true
,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fie
lds":[]},{"field_name":"SpendUser_biManager_value","field_type":"string","include":true,"field_forma
t":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fi
eld_name":"SpendUserPreference_showImagingIntro","field_type":"boolean","include":true,"field_format
":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fie
ld_name":"SpendUserPreference_expenseAuditRequired","field_type":"string","include":true,"field_form
at":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"f
ield_name":"SpendUserPreference_allowCreditCardTransArrivalEmails","field_type":"boolean","include":
true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col
_fields":[]},{"field_name":"SpendUserPreference_allowReceiptImageAvailEmails","field_type":"boolean"
,"include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":fal
se,"ref_col_fields":[]},{"field_name":"SpendUserPreference_promptForCardTransactionsOnReport","field
_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[]
,"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreference_autoAddTripCardTransOnRep
ort","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","
ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreference_promptForRepor
tPrintFormat","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascr
ipt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreference_defau
ltReportPrintFormat","field_type":"string","include":true,"field_format":"","field_source":"data","j
avascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreference
_showTotalOnReport","field_type":"boolean","include":true,"field_format":"","field_source":"data","j
avascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreference
_showExpenseOnReport","field_type":"boolean","include":true,"field_format":"","field_source":"data",
"javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPreferen
ce_showInstructHelpPanel","field_type":"boolean","include":true,"field_format":"","field_source":"da
ta","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPref
erence_useQuickItinAsDefault","field_type":"boolean","include":true,"field_format":"","field_source"
:"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUser
Preference_enableOcrForUi","field_type":"boolean","include":true,"field_format":"","field_source":"d
ata","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPre
ference_enableOcrForEmail","field_type":"boolean","include":true,"field_format":"","field_source":"d
ata","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendUserPre
ference_enableTripBasedAssistant","field_type":"boolean","include":true,"field_format":"","field_sou
rce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"Spend
InvoicePreference","field_type":"string","include":true,"field_format":"","field_source":"data","jav
ascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"EnterprisePayroll","f
ield_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col"
:[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_emailStatusChangeO
nCashAdvance","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascr
ipt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_e
mailAwaitApprovalOnCashAdvance","field_type":"boolean","include":true,"field_format":"","field_sourc
e":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWo
rkflowPreference_emailStatusChangeOnReport","field_type":"boolean","include":true,"field_format":"",
"field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_na
me":"SpendWorkflowPreference_emailAwaitApprovalOnReport","field_type":"boolean","include":true,"fiel
d_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[
]},{"field_name":"SpendWorkflowPreference_promptForApproverOnReportSubmit","field_type":"boolean","i
nclude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,
"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_emailStatusChangeOnTravelRequest","field
_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[]
,"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_emailAwaitApprovalOnT
ravelRequest","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascr
ipt":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_p
romptForApproverOnTravelRequestSubmit","field_type":"boolean","include":true,"field_format":"","fiel
d_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"
SpendWorkflowPreference_emailStatusChangeOnPayment","field_type":"boolean","include":true,"field_for
mat":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"
field_name":"SpendWorkflowPreference_emailAwaitApprovalOnPayment","field_type":"boolean","include":t
rue,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_
fields":[]},{"field_name":"SpendWorkflowPreference_promptForApproverOnPaymentSubmit","field_type":"b
oolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"referen
ce":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_emailOnPurchaseRequestStatusCh
ange","field_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"",
"ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkflowPreference_emailOnPu
rchaseRequestAwaitApproval","field_type":"boolean","include":true,"field_format":"","field_source":"
data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"SpendWorkfl
owPreference_promptForPurchaseRequestApproverOnSubmit","field_type":"boolean","include":true,"field_
format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]}
],"key":"id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"},{"col_name":"
spendCategoryCodes","fields":[{"field_name":"ID","field_type":"string","include":true,"field_format"
:"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"fiel
d_name":"Name","field_type":"string","include":true,"field_format":"","field_source":"data","javascr
ipt":"","ref_col":[],"reference":false,"ref_col_fields":[]}],"key":"","display":"","name_values":[],
"sys_nn":[],"container":"","source":"data"},{"col_name":"travel_users_customFields","fields":[{"fiel
d_name":"travelUser_id","field_type":"string","include":true,"field_format":"","field_source":"data"
,"javascript":"","ref_col":["travel_users"],"reference":false,"ref_col_fields":[]},{"field_name":"na
me","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","re
f_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"value","field_type":"string","includ
e":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_
col_fields":[]}],"key":"","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"},
{"col_name":"travel_users","fields":[{"field_name":"id","field_type":"string","include":true,"field_
format":"","field_source":"data","javascript":"","ref_col":["identity_users"],"reference":false,"ref
_col_fields":[]},{"field_name":"TravelUser_ruleClass_name","field_type":"string","include":true,"fie
ld_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":
[]},{"field_name":"TravelUser_ruleClass_id","field_type":"string","include":true,"field_format":"","
field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_nam
e":"TravelUser_travelCrsName","field_type":"string","include":true,"field_format":"","field_source":
"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser
_name_namePrefix","field_type":"string","include":true,"field_format":"","field_source":"data","java
script":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_name_givenN
ame","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","r
ef_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_name_hasNoMiddleName","f
ield_type":"boolean","include":true,"field_format":"","field_source":"data","javascript":"","ref_col
":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_name_middleName","field_type":
"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"refere
nce":false,"ref_col_fields":[]},{"field_name":"TravelUser_name_familyName","field_type":"string","in
clude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"
ref_col_fields":[]},{"field_name":"TravelUser_name_honorificSuffix","field_type":"string","include":
true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col
_fields":[]},{"field_name":"TravelUser_travelNameRemark","field_type":"string","include":true,"field
_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]
},{"field_name":"TravelUser_gender","field_type":"string","include":true,"field_format":"","field_so
urce":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"Trav
elUser_orgUnit","field_type":"string","include":true,"field_format":"","field_source":"data","javasc
ript":"","ref_col":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_manager_value
","field_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_
col":[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_manager_employeeNumber","fi
eld_type":"string","include":true,"field_format":"","field_source":"data","javascript":"","ref_col":
[],"reference":false,"ref_col_fields":[]},{"field_name":"TravelUser_groups","field_type":"string","i
nclude":true,"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,
"ref_col_fields":[]},{"field_name":"TravelUser_eReceiptOptIn","field_type":"boolean","include":true,
"field_format":"","field_source":"data","javascript":"","ref_col":[],"reference":false,"ref_col_fiel
ds":[]}],"key":"id","display":"","name_values":[],"sys_nn":[],"container":"","source":"data"}]}]
'@
