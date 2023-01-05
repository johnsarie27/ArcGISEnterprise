# Get-PortalOAuthToken

## SYNOPSIS
Get Portal OAuth token

## SYNTAX

```
Get-PortalOAuthToken [-Context] <Uri> [-Credential] <PSCredential> [[-Expiration] <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Generate OAuth token for Portal application

## EXAMPLES

### EXAMPLE 1
```
Get-PortalOAuthToken -Context 'https://arcgis.com/arcgis' -Credential $creds
Get OAuth token for Portal application
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

### -Expiration
Token expiration time in minutes

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 15
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
