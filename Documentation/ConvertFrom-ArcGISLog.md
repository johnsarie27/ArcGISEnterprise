# ConvertFrom-ArcGISLog

## SYNOPSIS
Convert from ArcGIS log

## SYNTAX

```
ConvertFrom-ArcGISLog [-Path] <String> [<CommonParameters>]
```

## DESCRIPTION
Convert from ArcGIS Server or Portal log to array of objects

## EXAMPLES

### EXAMPLE 1
```
ConvertFrom-ArcGISLog -Path "C:\logs\myLog.log"
Converts all entries in the log to objects
```

## PARAMETERS

### -Path
Path to log file

```yaml
Type: String
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

### System.String.
## OUTPUTS

### System.Management.Automation.PSCustomObject.
## NOTES
Name:     ConvertFrom-ArcGISLog
Author:   Justin Johns
Version:  0.1.4 | Last Edit: 2022-07-28
- 0.1.0 - Initial version
- 0.1.1 - Added pipeline input and ordered properties
- 0.1.2 - Added support for ArcGIS Server logs and renamed function
- 0.1.3 - Updated logic with try/catch for XML parsing errors
- 0.1.4 - Added support for dynamic columns
Comments: \<Comment(s)\>
General notes

## RELATED LINKS
