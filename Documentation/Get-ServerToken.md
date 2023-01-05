# Get-ServerToken

## SYNOPSIS
Generate token

## SYNTAX

```
Get-ServerToken [-Context] <Uri> [-Credential] <PSCredential> [[-Referer] <String>] [[-Client] <String>]
 [[-Expiration] <Int32>] [-Admin] [-SkipCertificateCheck] [<CommonParameters>]
```

## DESCRIPTION
Generate token for ArcGIS Server

## EXAMPLES

### EXAMPLE 1
```
Get-ServerToken -URL https://mydomain.com/arcgis -Credential $creds
Generate token for mydomain.com
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
Default value: Referer
Accept pipeline input: False
Accept wildcard characters: False
```

### -Client
Client

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: Requestip
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
Position: 5
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Admin
Use the Admin URL to generate the token

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
-- SERVER ENDPONITS --
https://myDomain.com/arcgis/admin/login
https://myDomain.com/arcgis/admin/generateToken

## RELATED LINKS
