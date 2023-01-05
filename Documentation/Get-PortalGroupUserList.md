# Get-PortalGroupUserList

## SYNOPSIS
Get users from group in Portal for ArcGIS

## SYNTAX

```
Get-PortalGroupUserList [-GroupID] <String> [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck]
 [<CommonParameters>]
```

## DESCRIPTION
Get users from group in Portal for ArcGIS

## EXAMPLES

### EXAMPLE 1
```
Get-PortalGroupUserList @commonParams -GroupID 'e24d7d38ce9646138fd4e5d6d17e5539'
Explanation of what the example does
```

## PARAMETERS

### -GroupID
Group ID

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
Name:     Get-PortalGroupUserList
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-09-29
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
