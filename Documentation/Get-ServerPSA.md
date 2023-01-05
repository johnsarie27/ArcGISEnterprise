# Get-ServerPSA

## SYNOPSIS
Get Portal user

## SYNTAX

```
Get-ServerPSA [-Context] <Uri> [-Token] <String> [[-Referer] <String>] [<CommonParameters>]
```

## DESCRIPTION
Get Portal user

## EXAMPLES

### EXAMPLE 1
```
Get-ServerPSA -Context 'https://arcgis.com/arcgis' -Token $token
Get PSA user from Server
```

## PARAMETERS

### -Context
ArcGIS Server context (e.g., https://arcgis.com/arcgis)

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

### -Referer
Portal referer

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Referer-value
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
