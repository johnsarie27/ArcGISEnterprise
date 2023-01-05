# Set-PortalRolePrivilege

## SYNOPSIS
Set privilege for Portal for ArcGIS Role

## SYNTAX

```
Set-PortalRolePrivilege [-RoleId] <String> [-Privilege] <String[]> [[-PortalId] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Set privilege for Portal for ArcGIS Role

## EXAMPLES

### EXAMPLE 1
```
Set-PortalRolePrivilege @commonParams -RoleId 123456 -Privilege @("portal:user:createItem","portal:user:joinGroup")
Set Portal role privileges for role ID '123456'
```

## PARAMETERS

### -RoleId
Portal Role ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Privilege
Portal role privilege

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalId
Portal ID

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Position: 5
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
Name:     Set-PortalRolePrivilege
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-07-19
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/users-groups-and-items/set-role-privileges.htm

## RELATED LINKS
