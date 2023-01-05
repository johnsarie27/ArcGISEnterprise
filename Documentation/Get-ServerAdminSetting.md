# Get-ServerAdminSetting

## SYNOPSIS
Get ArcGIS Server admin setting

## SYNTAX

```
Get-ServerAdminSetting [-Context] <Uri> [-SettingUrl] <String> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get ArcGIS Server admin setting

## EXAMPLES

### EXAMPLE 1
```
Get-ServerAdminSetting -Context https://arcgis.com/arcgis -SettingUrl 'admin/security/tokens'
Explanation of what the example does
```

## PARAMETERS

### -Context
Target Portal context

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

### -SettingUrl
ArcGIS Server setting URL

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
Name:      Get-ServerAdminSetting
Author:    Justin Johns
Version:   0.1.0 | Last Edit: 2022-04-15
- \<VersionNotes\> (or remove this line if no version notes)
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
