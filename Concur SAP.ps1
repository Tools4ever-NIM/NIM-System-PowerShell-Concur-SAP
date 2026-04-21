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
        @{ name = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User';            type = 'object';   objectfields = @("terminationDate","companyId","department","organization","manager.value","manager.employeeNumber","costCenter","startDate","leavesOfAbsence","employeeNumber");             options = @('default','create_o','update_o'); alias = 'EnterpriseUser' }
        @{ name = 'username';            type = 'string';   objectfields = $null;             options = @('default','create_m','update_o') }
    )
    IdentityUser_Address = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'country';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'locality';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'postalCode';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'region';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'streetAddress';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    IdentityUser_Email = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'verified';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'notifications';            type = 'boolean';   objectfields = $null;             options = @('default') }
    )
    IdentityUser_EmergencyContact = @(
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
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'display';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'notifications';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'primary';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'schemas';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'meta';            type = 'object';   objectfields = @("resourceType","created","lastModified","version","location");             options = @('default') }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:User';            type = 'object';   objectfields = @("reimbursementCurrency","reimbursementType","ledgerCode","country","budgetCountryCode","stateProvince","locale","cashAdvanceAccountCode","testEmployee","nonEmployee","biManager.value");             options = @('default'); alias = 'SpendUser' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:UserPreference';            type = 'object';   objectfields = @("showImagingIntro","expenseAuditRequired","allowCreditCardTransArrivalEmails","allowReceiptImageAvailEmails","promptForCardTransactionsOnReport","autoAddTripCardTransOnReport","promptForReportPrintFormat","defaultReportPrintFormat","showTotalOnReport","showExpenseOnReport","showInstructHelpPanel","useQuickItinAsDefault","enableOcrForUi","enableOcrForEmail","enableTripBasedAssistant");             options = @('default'); alias = 'SpendUserPreference' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:InvoicePreference';            type = 'string';   objectfields = $null;             options = @('default'); alias = 'SpendInvoicePreference' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:Payroll';            type = 'string';   objectfields = $null;             options = @('default'); alias = 'EnterprisePayroll' }
        @{ name = 'urn:ietf:params:scim:schemas:extension:spend:2.0:WorkflowPreference';            type = 'object';   objectfields = @("emailStatusChangeOnCashAdvance","emailAwaitApprovalOnCashAdvance","emailStatusChangeOnReport","emailAwaitApprovalOnReport","promptForApproverOnReportSubmit","emailStatusChangeOnTravelRequest","emailAwaitApprovalOnTravelRequest","promptForApproverOnTravelRequestSubmit","emailStatusChangeOnPayment","emailAwaitApprovalOnPayment","promptForApproverOnPaymentSubmit","emailOnPurchaseRequestStatusChange","emailOnPurchaseRequestAwaitApproval","promptForPurchaseRequestApproverOnSubmit");             options = @('default'); alias = 'SpendWorkflowPreference' }
    )
    SpendUser_CustomData = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'spenduser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'value';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'syncGuid';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'href';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser_Approver = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'spenduser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approver_value';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'primary';            type = 'boolean';   objectfields = $null;             options = @('default') }
    )
    SpendUser_ApproverLimit = @(
        @{ name = 'spenduser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'type';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalGroup';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalLimit';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'approvalType';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'exceptionApprovalAuthority';            type = 'boolean';   objectfields = $null;             options = @('default') }
        @{ name = 'reimbursementCurrency';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    SpendUser_Delegate = @(
        @{ name = 'spenduser_id';            type = 'string';   objectfields = $null;             options = @('default') }
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
    SpendUser_Roles = @(
        @{ name = 'spenduser_id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'roleName';            type = 'string';   objectfields = $null;             options = @('default') }
    )
    TravelUser = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
        @{ name = 'id';            type = 'string';   objectfields = $null;             options = @('default') }
        @{ name = 'urn:ietf:params:scim:schemas:extension:travel:2.0:User';            type = 'object';   objectfields = @("ruleClass.name","ruleClass.id","travelCrsName","name.namePrefix","name.givenName","name.hasNoMiddleName","name.middleName","name.familyName","name.honorificSuffix","travelNameRemark","gender","orgUnit","manager.value","manager.employeeNumber","groups","eReceiptOptIn" );             options = @('default'); alias = 'TravelUser' }
    )
    TravelUser_CustomField = @(
        @{ name = 'identityuser_id';            type = 'string';   objectfields = $null;             options = @('default','key') }
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
        Log info "$($ConnectionParams)"
        Log info "$($Connection)"
        $system_params   = ConvertFrom-Json2 $ConnectionParams
        Execute-Request -SystemParams $system_params -Method "GET" -Uri "profile/identity/v4.1/Users?count=1"

    }

    if ($Configuration) {
        @()
    }

    Log info "Done"
}

function Idm-OnUnload {
}

#
# Object CRUD functions
#

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
                [void]$Global:IdentityUsers.AddRange(@() + $response)
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

            foreach($item in $Global:IdentityUsers) {
                $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                foreach($prop in $item.PSObject.Properties) {
                    $schemaProp = $propertiesHT[$prop.Name]

                    if($schemaProp.Type -eq 'table') {
                        $ucFirst = $prop.Name.Substring(0,1).ToUpper() + $prop.Name.Substring(1)
                        $globalVar = Get-Variable "IdentityUsers_$ucFirst" -Scope Global -ErrorAction SilentlyContinue
                            foreach($subItem in $prop.Value) {
                                $table_template = [ordered]@{}
                                $table_template['id'] = $item.id
                                foreach($subProperty in $subItem.PSObject.Properties) {
                                    $table_template[$subProperty.Name] = $subProperty.Value
                                }
                                [void]$globalVar.Value.Add([PSCustomObject]$table_template)
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

                    if ($null -ne $schemaProp -and $properties.Name.Contains($prop.Name)) {
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
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'optional' }
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

        $uri = "profile/identity/v4.1/Users"             
        
        $alias = "{0}_" -f ($Global:Properties.$Class | ? { $_.Name -eq 'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'}).Alias
        $body = [PSObject]@{
            'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User' = [PSObject]@{}
            'name' = [PSObject]@{}
        }

        foreach($prop in ([PSCustomObject]$function_params).PSObject.properties) {
            if($prop.Name.StartsWith($alias)) {
                $fieldname = ($prop.Name.Replace($alias,''))
                $body.'urn:ietf:params:scim:schemas:extension:enterprise:2.0:User'.$fieldname = $prop.Value
            } elseif($prop.Name.StartsWith("name_")) {
                $fieldname = ($prop.Name.Replace("name_",''))
                $body.'name'.$fieldname = $prop.Value
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
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'optional' }
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
            } elseif($prop.Name.StartsWith("name_")) {
                $fieldname = ($prop.Name.Replace("name_",''))
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
                    Where-Object { $_.options -contains 'delete_m' } |
                    ForEach-Object {
                        @{ name = $_.name; allowance = 'mandatory' }
                    }

                $Global:Properties.$Class |
                    Where-Object { $_.options -contains 'delete_o' } |
                    ForEach-Object {
                        if ($_.Type -eq 'object') {
                            foreach ($field in $_.objectfields) {
                                $colPrefix = if ($_.alias) { $_.alias } else { $_.name }
                                @{ name = "$($colPrefix)_$($field)"; allowance = 'optional' }
                            }
                        } else {
                            @{ name = $_.name; allowance = 'optional' }
                        }
                    }

                $Global:Properties.$Class |
                    Where-Object { -not ( $_.options -contains 'delete_m' -or $_.options -contains 'delete_o' ) } |
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
            $cancellationToken = $cancellationSource.Token
            $system_params.CancellationSource = $cancellationSource

            $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
            $runspacePool.Open()
            $runspaces = @()

            # Index for tracking
            $index = 0

            $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef3 = "function Initialize-Proxy { $((Get-Command Initialize-Proxy -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef4 = "function Resolve-NestedValue { $((Get-Command Resolve-NestedValue -CommandType Function).ScriptBlock.ToString()) }"

            foreach ($item in $Global:IdentityUsers) {
                $runspace = [powershell]::Create()

                # Capture values before entering the runspace
                $proxySnapshot    = $Global:Proxy
                $authTokenSnapshot = $Global:AuthToken

                [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript($funcDef3).AddScript($funcDef4).AddScript({
                    param($item, $system_params, $Class, $template, $index, $properties, $propertiesHT, $proxy, $authToken)
                    
                    $Global:Proxy = $proxy
                    $Global:AuthToken = $authToken

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

                    $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                    $row.identityuser_id = $item.id

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
                }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($template).AddArgument($index).AddArgument($properties.Name).AddArgument($propertiesHT).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot)

                $runspace.RunspacePool = $runspacePool
                $runspaces += [PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index }
                $index++
            }

            # Collect results
            $total = $runspaces.Count
            $completed = 0

            foreach ($r in $runspaces) {
                $output = $r.Pipe.EndInvoke($r.Status)
                $completed++

                if ($completed % 250 -eq 0 -or $completed -eq $total) {
                    $percent = [math]::Round(($completed / $total) * 100, 2)
                    Log info "Progress: [$completed/$total] requests completed ($percent%)"
                }

                if($null -ne $output.logMessage) {
                    Log verbose $output.logMessage
                }
                


                foreach($item in $output.rawResult) {
                    
                    # CustomData
                    if($item.'urn:ietf:params:scim:schemas:extension:spend:2.0:User'.customData.length -gt 0) {
                        foreach($subItem in $item.'urn:ietf:params:scim:schemas:extension:spend:2.0:User'.customData) {
                            [void]$Global:SpendUsers_CustomData.Add([PSCustomObject]@{
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
                                spendUser_id = $item.id
                                roleName = $subItem.roleName
                                roleGroups = $subItem.roleGroups
                            })
                        }
                    }
                    
                }
                
                [void]$Global:SpendUsers.AddRange(@() + ($output.result | Select-Object $function_params.properties))

                $r.Pipe.Dispose()
            }

            $runspacePool.Close()
            $runspacePool.Dispose()
        }

        $Global:SpendUsers
}

function Idm-spend_users_customDataRead {
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
        $Class = 'SpendUser_Roles'
        
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
            $cancellationToken = $cancellationSource.Token
            $system_params.CancellationSource = $cancellationSource

            $runspacePool = [runspacefactory]::CreateRunspacePool(1, [int]$system_params.nr_of_threads)
            $runspacePool.Open()
            $runspaces = @()

            # Index for tracking
            $index = 0

            $funcDef = "function Execute-Request { $((Get-Command Execute-Request -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef2 = "function Execute-Authorization { $((Get-Command Execute-Authorization -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef3 = "function Initialize-Proxy { $((Get-Command Initialize-Proxy -CommandType Function).ScriptBlock.ToString()) }"
            $funcDef4 = "function Resolve-NestedValue { $((Get-Command Resolve-NestedValue -CommandType Function).ScriptBlock.ToString()) }"

            foreach ($item in $Global:IdentityUsers) {
                $runspace = [powershell]::Create()

                # Capture values before entering the runspace
                $proxySnapshot    = $Global:Proxy
                $authTokenSnapshot = $Global:AuthToken

                [void]$runspace.AddScript($funcDef).AddScript($funcDef2).AddScript($funcDef3).AddScript($funcDef4).AddScript({
                    param($item, $system_params, $Class, $template, $index, $properties, $propertiesHT, $proxy, $authToken)
                    
                    $Global:Proxy = $proxy
                    $Global:AuthToken = $authToken

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

                    $row = New-Object -TypeName PSObject -Property ([ordered]@{} + $template)
                    $row.identityuser_id = $item.id

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
                }).AddArgument($item).AddArgument($system_params).AddArgument($Class).AddArgument($template).AddArgument($index).AddArgument($properties.Name).AddArgument($propertiesHT).AddArgument($proxySnapshot).AddArgument($authTokenSnapshot)

                $runspace.RunspacePool = $runspacePool
                $runspaces += [PSCustomObject]@{ Pipe = $runspace; Status = $runspace.BeginInvoke(); Index = $index }
                $index++
            }

            # Collect results
            $total = $runspaces.Count
            $completed = 0

            foreach ($r in $runspaces) {
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
                        spendUser_id = $item.id
                        name = $subItem.name
                        value = $subItem.Value
                    })
                }

                [void]$Global:TravelUsers.AddRange(@() + ($output.result | Select-Object $function_params.properties))
                
                $r.Pipe.Dispose()
            }

            $runspacePool.Close()
            $runspacePool.Dispose()
        }

        $Global:TravelUsers
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
                $splat["proxyCredential"] - $Global:Proxy["ProxyCredential"]
            }
        }

        $Global:AuthToken = (Invoke-RestMethod @splat).access_token
}

function Execute-Request {
    param (
        [hashtable] $SystemParams,
        [string] $Method,
        [string] $Body,
        [string] $Uri,
        [string] $Path = $null,
        [boolean] $LoggingEnabled = $true
    )

    Initialize-Proxy -SystemParams $SystemParams

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
                ForEach-Object { "$($_.Key)=$($_.Value)" }
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
    $allData = @()
    $cursor = $null

    do {
        # Add cursor to query string if present
        if ($cursor) {
            $splat.Uri = ("https://{0}/{1}?cursor={2}" -f $SystemParams.geolocation, $Uri, $cursor)
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
        if($Path.length -lt 1) {
            $allData += $response

        } else {
            if ($response.$Path) {
                $allData += $response.$Path
            }
        }

        # Get next cursor
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
