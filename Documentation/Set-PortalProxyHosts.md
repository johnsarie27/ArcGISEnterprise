# Set-PortalProxyHosts

## SYNOPSIS
Set Portal security configuration

## SYNTAX

```
Set-PortalProxyHosts [-Context] <Uri> [-ProxyHost] <String[]> [[-Referer] <String>] [-Token] <String>
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Set Portal security configuration

## EXAMPLES

### EXAMPLE 1
```
$cmn = @{ Context = 'https://arcgis.com/arcgis'; Token = $token }
PS C:\> Set-PortalSecurityConfiugration -ProxyHost 'test.com' @cmn
Set Portal allowedProxyHosts to 'test.com'
```

## PARAMETERS

### -Context
Portal context (e.g., https://arcgis.com/arcgis)

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

### -ProxyHost
Proxy host

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

### -Referer
Referer

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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
Position: 4
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
Name:     Set-PortalProxyHosts
Author:   Justin Johns
Version:  0.1.2 | Last Edit: 2023-01-05
- 0.1.2 - Fixed minor issue with setting allowed origins
- 0.1.1 - Fixed defect that removes several existing properties
- 0.1.0 - Initial version
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
