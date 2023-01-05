# Get-PortalUserList

## SYNOPSIS
Get Portal user list

## SYNTAX

```
Get-PortalUserList [[-PortalId] <String>] [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get list of all Portal users

## EXAMPLES

### EXAMPLE 1
```
Get-PortalUserList -Context 'https://arcgis.com/arcgis' -Token $token
Get users from Portal
```

## PARAMETERS

### -PortalId
Portal ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0123456789ABCDEF
Accept pipeline input: False
Accept wildcard characters: False
```

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
Portal token

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCertificateCheck
Ignore missing or invalid certificate

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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
Name:     Get-PortalUserList
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2022-10-17
- 0.1.0 - Initial version
- 0.1.1 - Makes multiple requests to get all users if more than 100
- 0.1.2 - Changed array to generic list
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/users-groups-and-items/users.htm

## RELATED LINKS
