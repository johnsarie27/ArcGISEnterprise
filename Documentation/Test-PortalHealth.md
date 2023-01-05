# Test-PortalHealth

## SYNOPSIS
Test Portal health

## SYNTAX

```
Test-PortalHealth [-Context] <Uri> [[-Token] <String>] [-SkipCertificateCheck] [[-TimeoutSec] <Int32>]
 [<CommonParameters>]
```

## DESCRIPTION
Send a request to the Portal health check endpoint

## EXAMPLES

### EXAMPLE 1
```
Test-PortalHealth -Context 'https://arcgis.com/arcgis'
Send a request to the Portal heealth check endpoint
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

Required: False
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

### -TimeoutSec
Specifies how long the request can be pending before it times out

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 0
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

## RELATED LINKS
