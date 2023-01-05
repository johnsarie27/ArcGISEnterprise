# New-PortalRole

## SYNOPSIS
Create new Role in Portal for ArcGIS

## SYNTAX

```
New-PortalRole [-Name] <String> [-Description] <String> [[-PortalId] <String>] [-Context] <Uri>
 [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Create new Role in Portal for ArcGIS

## EXAMPLES

### EXAMPLE 1
```
New-PortalRole @commonParams -Name 'testRole' -Description 'testRole'
Create new role 'testRole' in Portal for ArcGIS
```

## PARAMETERS

### -Name
Role name

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

### -Description
Role description

```yaml
Type: String
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
Name:     New-PortalRole
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-07-19
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes
https://developers.arcgis.com/rest/users-groups-and-items/create-role.htm

## RELATED LINKS
