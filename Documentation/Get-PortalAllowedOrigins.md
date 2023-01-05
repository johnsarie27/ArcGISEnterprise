# Get-PortalAllowedOrigins

## SYNOPSIS

## SYNTAX

```
Get-PortalAllowedOrigins [-Context] <Uri> [-Token] <String> [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Get the allowed origins configured for ArcGIS Portal

## EXAMPLES

### EXAMPLE 1
```
$params = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
PS C:\> Get-PortalAllowedOrigins @params
Gets the allowed origins for ArcGIS Portal
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

### -Token
Portal token

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

### System.String.
## NOTES
Name:     Get-PortalAllowedOrigins
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-04-27
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
