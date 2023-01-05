# Update-ServerPSA

## SYNOPSIS
Update ArcGIS Server PSA Account

## SYNTAX

```
Update-ServerPSA [-Context] <Uri> [-Credential] <PSCredential> [-NewPassword] <PSCredential>
 [<CommonParameters>]
```

## DESCRIPTION
Update ArcGIS Server PSA Account

## EXAMPLES

### EXAMPLE 1
```
<example usage>
Explanation of what the example does
```

## PARAMETERS

### -Context
ArcGIS Server context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Credential
PSCredential object containing current username and password

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewPassword
PSCredential object containing new password

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
General notes
https://developers.arcgis.com/rest/enterprise-administration/server/psa.htm
https://developers.arcgis.com/rest/enterprise-administration/server/updatepsa.htm
https://developers.arcgis.com/rest/users-groups-and-items/update-user.htm

## RELATED LINKS
