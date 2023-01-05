# Get-PortalSecurityPolicy

## SYNOPSIS
Get Portal security policy

## SYNTAX

```
Get-PortalSecurityPolicy [-Context] <Uri> [-Token] <String> [[-Id] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Portal security policy for user of provided token

## EXAMPLES

### EXAMPLE 1
```
Get-SecurityPolicy -Context 'https://arcgis.com/arcgis' -Token $token
Get security policy for Portal user
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

### -Id
Portal internal ID

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None.
## OUTPUTS

### System.Object.
## NOTES
General notes

## RELATED LINKS
