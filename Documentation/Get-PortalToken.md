# Get-PortalToken

## SYNOPSIS

## SYNTAX

```
Get-PortalToken [-Context] <Uri> [-Credential] <PSCredential> [[-Referer] <String>] [[-Expiration] <Int32>]
 [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Generate token for ArcGIS Portal

## EXAMPLES

### EXAMPLE 1
```
Get-PortalToken -Context https://mydomain.com/arcgis -Credential $creds
Generate token for mydomain.com
```

## PARAMETERS

### -Context
Portal URI including context (e.g., https://arcgis.com/arcgis)

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
PowerShell credential object containing username and password

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

### -Expiration
Token expiration time in minutes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 60
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
General notes

## RELATED LINKS
