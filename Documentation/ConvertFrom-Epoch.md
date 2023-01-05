# ConvertFrom-Epoch

## SYNOPSIS
Convert from Epoch to DateTime

## SYNTAX

```
ConvertFrom-Epoch [-Milliseconds] <Int64[]> [<CommonParameters>]
```

## DESCRIPTION
Convert from Epoch in milliseconds to DateTime

## EXAMPLES

### EXAMPLE 1
```
1618614176000 | ConvertFrom-Epoch
Convert Epoch time of 1618614176000 to a DateTime object
```

## PARAMETERS

### -Milliseconds
Epoch Time in milliseconds

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Int64.
## OUTPUTS

### System.DateTime.
## NOTES
Name:     ConvertFrom-Epoch
Author:   Justin Johns
Version:  0.1.0 | Last Edit: 2022-06-07
- \<VersionNotes\> (or remove this line if no version notes)
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
