/*
 * DatePicker.j
 *
 * Created by Randall Luecke.
 * Copyright 2009, RCL Concepts.
 * http://www.rclconcepts.com/
 * http://www.timetableapp.com/
 *
 * This file is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 */
 
@import <AppKit/CPControl.j>
@import "Stepper.j"

CPLogRegister(CPLogConsole);

@implementation DatePicker : CPControl
{
	CPView		_theView @accessors;
	Stepper 	_theStepper @accessors;
	CPArray		segments @accessors;
	id			superController @accessors;
	
	CPDate		_date;
	CPDate		_minDate;
	CPDate		_maxDate;
	
	id 			bezel;
	id			bezelFocused;
	id			dateSegmentFocused;
	
	BOOL		focused @accessors;
	id			inputManager @accessors;
	id			currentFocusedSegment @accessors;
	id			lastFocusedSegment @accessors; //not used any longer I don't believe
	id			_delegate;
	
	//used from the input manager migrations
	id activeDateSegment @accessors;
    id prevActiveDateSegment @accessors;
	id superController @accessors;
	
	BOOL _dontsetfirsttome;
	
}

- (id)initWithFrame:aFrame
{
	self = [super initWithFrame:aFrame];
	if(self){
		_theView = [[CPView alloc] initWithFrame:CGRectMake(4, 3, CGRectGetWidth(aFrame) - 20, 23)];
		
		//bezel = [CPColor whiteColor];
		//bezelFocused = [CPColor whiteColor];
		
		bezel = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
            [
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-0.png" size:CGSizeMake(2.0, 3.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-1.png" size:CGSizeMake(1.0, 3.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-2.png" size:CGSizeMake(2.0, 3.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-3.png" size:CGSizeMake(2.0, 1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-4.png" size:CGSizeMake(1.0, 1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-5.png" size:CGSizeMake(2.0, 1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-6.png" size:CGSizeMake(2.0, 2.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-7.png" size:CGSizeMake(1.0, 2.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-8.png" size:CGSizeMake(2.0, 2.0)]
            ]]];
            
         bezelFocused = [CPColor colorWithPatternImage:[[CPNinePartImage alloc] initWithImageSlices:
            [
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-0.png" size:CGSizeMake(6.0,  7.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-1.png" size:CGSizeMake(1.0,  7.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-2.png" size:CGSizeMake(6.0,  7.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-3.png" size:CGSizeMake(6.0,  1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-4.png" size:CGSizeMake(1.0,  1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-5.png" size:CGSizeMake(6.0,  1.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-6.png" size:CGSizeMake(6.0,  5.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-7.png" size:CGSizeMake(1.0,  5.0)],
                [[CPImage alloc] initByReferencingFile:"Frameworks/AppKit/Resources/Aristo.blend/Resources/textfield-bezel-square-focused-8.png" size:CGSizeMake(6.0,  5.0)]
            ]]];
		
		[_theView setBackgroundColor:bezel];
		
		
		inputManager = self;//[[DatePickerInputManager alloc] init];
		[inputManager setSuperController:self];
		
		_theStepper = [[Stepper alloc] initWithFrame:CGRectMake(aFrame.size.width -13, 3, 13, 23)];
		[_theStepper setTarget:self];
		[_theStepper setAction:@selector(stepperAction:)];
		
		[self addSubview:_theView];
		[self addSubview:_theStepper];
	
		
		_date 	 = [CPDate dateWithTimeIntervalSinceNow:0];
		_maxDate = [CPDate distantFuture];
		_minDate = [CPDate distantPast];
		segments = [[CPArray alloc] init];
		
		focused = NO;
		[_theStepper setEnabled:NO];
		[_theStepper setMaxValue:9999];
		[_theStepper setMinValue:-1];
		

	}
	
	return self;
}

-(void)setDelegate:(id)aDelegate
{
	var defaultCenter = [CPNotificationCenter defaultCenter];
    
    //unsubscribe the existing delegate if it exists
    if (_delegate)
    {
        [defaultCenter removeObserver:_delegate name:"datePickerDidChangeNotification" object:self];
    }
    
    _delegate = aDelegate;
    
    if ([_delegate respondsToSelector:@selector(datePickerDidChange:)]){
        [defaultCenter addObserver:_delegate selector:@selector(datePickerDidChange:) name:"datePickerDidChangeNotification" object:self];
   	}
   	
   	if ([_delegate respondsToSelector:@selector(datePickerDidLoseFocus:)]){
        [defaultCenter addObserver:_delegate selector:@selector(datePickerDidLoseFocus:) name:"datePickerDidLoseFocusNotification" object:self];
   	}
}

//this method doesn't actually work... yet...
- (void)addDateSegmentOfType:(id)segmentType withInitialValue:(CPString)stringValue withSeperatorAtEnd:(CPString)seperator
{
	var aFrameSize = [self makeFrameForType:segmentType];

	var newSegment = [[DateSegment alloc] initWithFrame:CGRectMake(6, 7, 20, 18)];
	[dateSegmentes addObject:newSegment];
	[self addSubview: newSegment];
}

- (void)displayPreset:(id)type
{
	if(type == 1){ //type is stardard date
		var _theMonthField = [[DateSegment alloc] initWithFrame:CGRectMake(6, 7, 20, 18)];
		[_theMonthField setStringValue:@"00"];
		[_theMonthField sizeToFit];
		[_theMonthField setDelegate:self];
		[_theMonthField setInputManager: self];
		[_theMonthField setSuperController:self];
		[_theMonthField setDateType:1];
		//[_theMonthField setStringValue: [self date].getMonth() + 1];
		if(CGRectGetHeight([self frame]) - CGRectGetHeight([_theMonthField frame]) < 14)
		{
			[self setFrame:CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), CGRectGetHeight([_theMonthField frame]) + 14)];
			[_theView setFrame:CGRectMake(CGRectGetMinX([_theView frame]), CGRectGetMinY([_theView frame]), CGRectGetWidth([_theView frame]), CGRectGetHeight([_theMonthField frame]) + 6)];
		}
		
		var _theDayField = [[DateSegment alloc] initWithFrame:CGRectMake(28, 7, 20, 18)];
		[_theDayField setStringValue:@"00"];
		[_theDayField sizeToFit];
		[_theDayField setDelegate:self];
		[_theDayField setInputManager: self];
		[_theDayField setSuperController:self];
		[_theDayField setDateType:2];
		//[_theDayField setStringValue: [self date].getDate()];
		
		var _theYearField = [[DateSegment alloc] initWithFrame:CGRectMake(50, 7, 35, 18)];
		[_theYearField setStringValue:@"0000"];
		[_theYearField sizeToFit];
		[_theYearField setDelegate:self];
		[_theYearField setInputManager: self];
		[_theYearField setSuperController:self];
		[_theYearField setDateType:3];
		//[_theYearField setStringValue: [self date].getFullYear()];
					
		[self addSubview: _theMonthField];
		[self addSubview: _theDayField];
		[self addSubview: _theYearField];
		[segments addObject:_theMonthField];
		[segments addObject:_theDayField];
		[segments addObject:_theYearField];
		
		
		var slash1 = [[CPTextField alloc] initWithFrame:CGRectMake(23, 7, 15, 18)];
		[slash1 setStringValue:@"/"];
		[slash1 sizeToFit];
		
		var slash2 = [[CPTextField alloc] initWithFrame:CGRectMake(44, 7, 15, 18)];
		[slash2 setStringValue:@"/"];
		[slash2 sizeToFit];
		
		[self addSubview:slash1];
		[self addSubview:slash2];
		
	}else if(type == 2){ //type is stardard time
		var hoursField = [[DateSegment alloc] initWithFrame:CGRectMake(6, 7, 20, 18)];
		[hoursField setStringValue:@"00"];
		[hoursField sizeToFit];
		[hoursField setDelegate:self];
		[hoursField setInputManager: self];
		[hoursField setSuperController:self];
		[hoursField setDateType:9];
		
		if(CGRectGetHeight([self frame]) - CGRectGetHeight([hoursField frame]) < 14)
		{
			[self setFrame:CGRectMake(CGRectGetMinX([self frame]), CGRectGetMinY([self frame]), CGRectGetWidth([self frame]), CGRectGetHeight([hoursField frame]) + 14)];
			[_theView setFrame:CGRectMake(CGRectGetMinX([_theView frame]), CGRectGetMinY([_theView frame]), CGRectGetWidth([_theView frame]), CGRectGetHeight([hoursField frame]) + 6)];
		}
		
		/*if([self date].getHours() > 12){
			var shrotHurStr = [self date].getHours() - 12;	
		}else if([self date].getHours() < 1){
			shrotHurStr = 12;
		}else{
			var shrotHurStr = [self date].getHours();	
		}*/
		//[hoursField setStringValue:shrotHurStr];
		
		var minutesField = [[DateSegment alloc] initWithFrame:CGRectMake(28, 7, 20, 18)];
		[minutesField setStringValue:@"00"];
		[minutesField sizeToFit];
		[minutesField setDelegate:self];
		[minutesField setInputManager: self];
		[minutesField setSuperController:self];
		[minutesField setDateType:8];
		//[minutesField setStringValue: [self date].getMinutes()];
		//[minutesField setStringValue: [minutesField doubleNumber:[minutesField stringValue]]];
		
		var AMPMField = [[DateSegment alloc] initWithFrame:CGRectMake(45, 7, 20, 18)];
		[AMPMField setStringValue:@"AM"];
		[AMPMField sizeToFit];
		[AMPMField setDelegate:self];
		[AMPMField setInputManager: self];
		[AMPMField setSuperController:self];
		[AMPMField setDateType:10];
		//var ampmstr = ([self date].getHours() > 11) ? @"PM" : "AM";
		//[AMPMField setStringValue: ampmstr];

		[self addSubview: hoursField];
		[self addSubview: minutesField];
		[self addSubview: AMPMField];
		[segments addObject: hoursField];
		[segments addObject: minutesField];
		[segments addObject: AMPMField];
		
		var slash1 = [[CPTextField alloc] initWithFrame:CGRectMake(23, 7, 15, 18)];
		[slash1 setStringValue:@":"];
		
		//var slash2 = [[CPTextField alloc] initWithFrame:CGRectMake(44, 7, 15, 18)];
		//[slash2 setStringValue:@":"];
		
		[self addSubview:slash1];
		//[self addSubview:slash2];
		
		
		
	}
	
	[self updatePickerDisplay];
}

- (CPDate)minDate
{
	return _minDate;
}

- (void)setMinDate:(CPDate)aDate
{
	_minDate = aDate;
	if([self Date] < [self minDate]){
		[self setDate: [self minDate]];
	}
}

- (CPDate)maxDate
{
	return _maxDate;
}

- (void)setMaxDate:(CPDate)aDate
{
	_maxDate = aDate;
	if([self date] < [self maxDate]){
		[self setDate: [self maxDate]];
	}
}

- (CPDate)date
{
	return _date;
}

- (void)setDate:(CPDate)aDate
{
	_date = aDate;
	[self updatePickerDisplay];
	
}

- (void)updatePickerDisplay
{
	for(var i = 0; i < [segments count]; i++)
	{
		var segment = [segments objectAtIndex:i];
		//console.log(segment);
		if([segment dateType] == 1){
			var strValue = [self date].getMonth() + 1;
			[segment setStringValue:[segment singleNumber:strValue]];
		}else if([segment dateType] == 2){
			var strValue = [self date].getDate();
			[segment setStringValue:[segment doubleNumber:strValue]];
		}else if([segment dateType] == 3){
			var strValue = [self date].getFullYear();
			[segment setStringValue:[segment quadNumber:strValue]];
		}else if([segment dateType] == 8){
			var strValue = [self date].getMinutes();
			[segment setStringValue:[segment doubleNumber:strValue]];
		}else if([segment dateType] == 9){
			var strValue = [self date].getHours();
			//console.log([self date]);
			if(strValue > 12){
				strValue = strValue - 12;
			}else if([self date].getHours() == 0){
				strValue = 12;
			}
			[segment setStringValue:[segment singleNumber:strValue]];
		}else if([segment dateType] == 10){
			var strValue = [self date].getHours();
			if(strValue > 11){
				strValue = @"PM";
			}else{
				strValue = @"AM";
			}
			[segment setStringValue:[segment singleNumber:strValue]];
		}
	}
}

- (BOOL)becomeFirstResponder
{
	if(!currentFocusedSegment)
		[self setActiveDateSegment: [segments objectAtIndex:0]];
	return YES;
}

- (BOOL)acceptsFirstResponder
{
	
	return YES;
}

- (BOOL)resignFirstResponder
{
	//[super resignFirstResponder];	
	//[self setFocused:NO];
//	console.log("resign");
//	[[self window] selectNextKeyView:self];
	//[[self window] sendEvent:anEvent]; //it doesn't work unless the event is sent twice... idk why.
    [self setPrevActiveDateSegment:[self activeDateSegment]];
	[self setActiveDateSegment:nil];
	//_dontsetfirsttome = NO;
	[[CPNotificationCenter defaultCenter] postNotificationName:"datePickerDidLoseFocusNotification" object:superController userInfo:nil];
	return YES;
}

- (void)mouseDown:(CPEvent)anEvent
{
	[super mouseDown:anEvent];
	//[self setFocused:YES];
	if(!currentFocusedSegment){
		[self setActiveDateSegment:[segments objectAtIndex:0]];
		[[self window] makeFirstResponder:self];
	}
}

- (void)setFocused:(BOOL)val
{
	if(focused === val)
		return;
		
	
	focused = val;
	
	if(focused){
		[_theView setFrame:CGRectMake([_theView frame].origin.x - 4, [_theView frame].origin.y - 3, [_theView frame].size.width + 8, [_theView frame].size.height + 6)];
		[_theView setBackgroundColor:bezelFocused];
		//[inputManager setActiveDateSegment:[segments objectAtIndex:0]];
	}else{
		[_theView setBackgroundColor:bezel];
		[_theView setFrame:CGRectMake([_theView frame].origin.x + 4, [_theView frame].origin.y + 3, [_theView frame].size.width - 8, [_theView frame].size.height - 6)];
	}
}

- (int)maxDays
{
	//check the month and find the max number of days for that month and return it. 
	
	if([self date].getFullYear() >= [self maxYear] && [self date].getMonth() >= [self maxMonth]){
		//console.log("bug in MaxDay");
		return [self maxDate].getDate();
	}
	
	//should also check for the max date
	var month = [self date].getMonth();
	var days = nil;
	
	if(month == 0 || month == 2 || month == 4 || month == 6 || month == 7 || month == 9 || month == 11){
		days = 31;
	}else if(month == 1){
		//check for leap year
		days = 28;
		if([self isLeapYear]){
			days++;
		}
		
	}else if(month == 3 || month == 5 || month == 8 || month == 10){
		days = 30;
	}else{
		days = 0;
	}
	
	return days;
}

- (int)maxMonth
{
	//default would be 12 but check for the max date
	if([self date].getFullYear() >= [self maxYear]){
		//console.log("bug in maxMonth");
		return [self maxDate].getMonth() + 1;
	}else{
		return 12;
	}
	
}

- (int)maxYear
{
	//check for the max year
	
	if([self maxDate]){
		//console.log("bug in maxYear");
		return [self maxDate].getFullYear();
	}else{
		return 9999;
	}
}

- (int)minDays
{
	//check the month and find the max number of days for that month and return it. 
	
	if([self date].getFullYear() <= [self minYear] && [self date].getMonth() <= [self minMonth]){
		return [self minDate].getDate();
	}
	
	//should also check for the max date
	var days = 1;
	
	return days;
}

- (int)minMonth
{
	//default would be 12 but check for the max date
	if([self date].getFullYear() <= [self minYear]){
		return [self minDate].getMonth() + 1;
	}else{
		return 1;
	}
	
}

- (int)minYear
{
	//check for the max year
	var theMinYear = [self minDate].getFullYear();
	
	if([self minDate]){
		return [self minDate].getFullYear();
	}else{
		return 1;
	}
}

- (int)maxHours
{
	return 12;
}

- (int)maxMins
{
	return 59;
}

- (int)maxAMPM
{
	return 1;
}

- (void)minHours
{
	return 1;
}

- (void)minMins
{
	return 0;
}

- (void)minAMPM
{
	return 0;
}

- (BOOL)isLeapYear
{
	var yr = [self date].getFullYear();
 	return !(yr % 4) && (yr % 100) || !(yr % 400) ? true : false;
}



- (void)setActiveDateSegment:(id)newSegment
{	
	if(activeDateSegment === newSegment)
		return;

	if([self activeDateSegment]){
		[self setLastFocusedSegment:activeDateSegment];
		[activeDateSegment makeInactive];
	}
	
	activeDateSegment = newSegment;
	
	if(activeDateSegment){
		[self setFocused:YES];
		[activeDateSegment makeActive];
		[self setCurrentFocusedSegment:activeDateSegment]; //must be called before resetting the first responder. 
		[[self window] makeFirstResponder:self];
		//}
	}else{
		[self setFocused:NO];
		[self setCurrentFocusedSegment:activeDateSegment];
	}
}	

- (void)keyDown:(id)anEvent
{
	[self interpretKeyEvents:anEvent];		
}

-(void)interpretKeyEvents:(id)anEvent
{
	var key = [anEvent keyCode];
	
	if(key == CPTabKeyCode){
		if([self activeDateSegment] == [segments objectAtIndex:[[superController segments] count] -1]){
//			[[self window] makeFirstResponder: [superController nextResponder]];
			//[superController slectNextFirstResponder:anEvent];
			//alert([[self window] firstResponder]);
			[[self window] selectNextKeyView:self];
			//alert([[self window] firstResponder]);
			
			/*[[self window] sendEvent:anEvent];
			if([[[self window] firstResponder] class] == [self class])
				[[self window] sendEvent:anEvent];*/
				
			return;
		}else{
			var i = [segments indexOfObject:[self activeDateSegment]];
			i++;
			i = [segments objectAtIndex:i];
		}
		[self setActiveDateSegment:i];
	}else if(key == CPRightArrowKeyCode || key == 189 || key == 188 || key == 190 || key == 191 || key == 186){
		if([self activeDateSegment] == [segments objectAtIndex:[segments count] -1]){
			i = [segments objectAtIndex:0];
		}else{
			var i = [segments indexOfObject:[self activeDateSegment]];
			i++;
			i = [segments objectAtIndex:i];
		}
		[self setActiveDateSegment:i];
	}else if(key == CPLeftArrowKeyCode){
		if([self activeDateSegment] == [segments objectAtIndex:0]){
			i = [segments objectAtIndex:[segments count] -1];
		}else{
			var i = [segments indexOfObject:[self activeDateSegment]];
			i--;
			i = [segments objectAtIndex:i];
		}
		[self setActiveDateSegment:i];
	}else if(key == CPDeleteKeyCode && [activeDateSegment dateType] !== 10){
		//send delete key
		[activeDateSegment removeLastChar];
	}else if(key == CPUpArrowKeyCode){
		//send increment
		[activeDateSegment increment];
	}else if(key == CPDownArrowKeyCode){
		//send decrement
		[activeDateSegment decrement];
	}else if(key == 48 || key == 96){
		[activeDateSegment sendNewInput: @"0"];
	}else if(key == 49 || key == 97){
		[activeDateSegment sendNewInput: @"1"];
	}else if(key == 50 || key == 98){
		[activeDateSegment sendNewInput: @"2"];
	}else if(key == 51 || key == 99){
		[activeDateSegment sendNewInput: @"3"];
	}else if(key == 52 || key == 100){
		[activeDateSegment sendNewInput: @"4"];
	}else if(key == 53 || key == 101){
		[activeDateSegment sendNewInput: @"5"];
	}else if(key == 54 || key == 102){
		[activeDateSegment sendNewInput: @"6"];
	}else if(key == 55 || key == 103){
		[activeDateSegment sendNewInput: @"7"];
	}else if(key == 56 || key == 104){
		[activeDateSegment sendNewInput: @"8"];
	}else if(key == 57 || key == 105){
		[activeDateSegment sendNewInput: @"9"];
	}else if(key == 65 && [activeDateSegment dateType] == 10){
		[activeDateSegment sendNewInput: @"A"];
	}else if(key == 80 && [activeDateSegment dateType] == 10){
		[activeDateSegment sendNewInput: @"P"];
	}

}

- (void)stepperAction:(id)sender
{
    //if the stepper is clicked and the date picker isn't active make it active.
    //if the date picker was previously selected then select that segment
    //otherwise select the first one.
    //FIX ME: the stepper needs to be clicked twice before the value changes.  
    if(!activeDateSegment)
		[self setActiveDateSegment:(prevActiveDateSegment) ? prevActiveDateSegment : [segments objectAtIndex:0]];

		var newValue = [_theStepper intValue];
		//[self setActiveDateSegment:[superController currentFocusedSegment]];
		
		if([activeDateSegment dateType] == 1){
			var maxValue = [self maxMonth];
			var minValue = [self minMonth];
			if(newValue > maxValue){
				newValue = minValue;
			}else if(newValue < minValue){
				newValue = maxValue;
			}
			
			/*if([superController date].getDate() > [superController maxDays]){
				[superController date].setDate([superController maxDays]);
				[superController updatePickerDisplay];
			}*/
			
			[self date].setMonth(newValue - 1);
			
			
			
		}else if([activeDateSegment dateType] == 2){
			var maxValue = [self maxDays];
			var minValue = [self minDays];
			if(newValue > maxValue){
				newValue = minValue;
			}else if(newValue < minValue){
				newValue = maxValue;
			}
			
			[superController date].setDate(newValue);
			newValue = [activeDateSegment doubleNumber:newValue];
			
		}else if([activeDateSegment dateType] == 3){
			var maxValue = [self maxYear];
			var minValue = [self minYear];
			if(newValue > maxValue){
				newValue = minValue;
			}else if(newValue < minValue){
				newValue = maxValue;
			}
			[superController date].setFullYear(newValue);
		}else if([activeDateSegment dateType] == 8){ //THIS BEGINS THE TIME PORTION
			var maxValue = [self maxMins];
			var minValue = [self minMins];
			if(newValue > maxValue){
				newValue = minValue;
			}else if(newValue < minValue){
				newValue = maxValue;
			}
			[superController date].setMinutes(newValue);
			newValue = [activeDateSegment doubleNumber:newValue];
			
		}else if([activeDateSegment dateType] == 9){
			var maxValue = [self maxHours];
			var minValue = [self minHours];
			if(newValue > maxValue){
				newValue = minValue;
			}else if(newValue < minValue){
				newValue = maxValue;
			}
			
			var oldValue = newValue;
			var ampm = [segments objectAtIndex:[segments count] - 1];
			if([ampm stringValue] === "PM" && newValue !== 12){
				newValue = newValue + 12;
			}else if([ampm stringValue] === "AM" && newValue == 12){
				newValue = 0;
			}
			
			[self date].setHours(newValue);
			
			newValue = oldValue;
			
			
		}else if([activeDateSegment dateType] == 10){
			var maxValue = [self maxAMPM];
			var minValue = [self minAMPM];
			
			if(newValue == maxValue || newValue < minValue){ //if it's PM
				newValue = maxValue;
				var strValue = @"PM"
				var newHrs = [self date].getHours();
				if(newHrs < 12){
					newHrs = newHrs + 12;
				}

			}else if(newValue == minValue || newValue > maxValue){ //it's AM
				newValue = minValue;
				var strValue = @"AM"
				var newHrs = [self date].getHours();
				if(newHrs > 11){
					newHrs = newHrs - 12;
				}

			}
			
			[self date].setHours(newHrs);
			[activeDateSegment setStringValue:strValue];
			[[self _theStepper] setIntValue:newValue];
			[[CPNotificationCenter defaultCenter] postNotificationName:"datePickerDidChangeNotification" object:superController userInfo:nil];
			return; //early return
		}
		
		[activeDateSegment setStringValue:newValue];
		[_theStepper setIntValue:[activeDateSegment stringValue]];
		
		[[CPNotificationCenter defaultCenter] postNotificationName:"datePickerDidChangeNotification" object:superController userInfo:nil];
//	[superController updatePickerDisplay];
}

@end

/*Custom CPTextField for a segment of the date*/

@implementation DateSegment : CPTextField
{
	id inputManager @accessors; //the input manager handels inputs... will probably be a textField but it's defined in DatePicker not this class.
	id superController @accessors; //the input manager is now part of superController
	
	id dateType @accessors;
	
	/**********************
	Date Type enum: 
	
	1.  number month field
	2.  number day field
	3.  full number year field
	
	4.  short name month field
	5.  short year (last two digits) ?? 
	
	6.  day of week short
	7.  day of week long
	
	8.  minutes
	9.  hours
	10. APMP
	11. seconds ??
	**********************/
	
	CPColor focusedBackground;
}

- (id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if(self){
		focusedBackground = [CPColor colorWithPatternImage:[[CPThreePartImage alloc] initWithImageSlices:
			[
				[[CPImage alloc] initByReferencingFile:"Resources/DatePicker/date-segment-left.png" size:CGSizeMake(4.0, 18.0)],
				[[CPImage alloc] initByReferencingFile:"Resources/DatePicker/date-segment-center.png" size:CGSizeMake(1.0, 18.0)],
				[[CPImage alloc] initByReferencingFile:"Resources/DatePicker/date-segment-right.png" size:CGSizeMake(4.0, 18.0)]
			] isVertical:NO]];
			
		[self setValue:CPRightTextAlignment forThemeAttribute:@"alignment"];
	}
	
	return self;
}

- (void)mouseDown:(CPEvent)anEvent
{
  	[inputManager setActiveDateSegment:self];
	//[[self window] makeFirstResponder:[inputManager inputManager]];
	[[superController _theStepper] setIntValue:[self stringValue]];
	
	if([self dateType] == 10 && [self stringValue] === @"AM"){
		[[superController _theStepper] setIntValue:0];	
	}else if([self dateType] == 10 && [self stringValue] === @"PM"){
		[[superController _theStepper] setIntValue:1];	
	}
   
}

- (void)setStringValue:(id)aValue
{
	[super setStringValue:aValue];
	
	[[superController _theStepper] setDoubleValue:[self intValue]];
	
	if([self dateType] == 10 && [self stringValue] == @"PM"){
		[[superController _theStepper] setDoubleValue:1];	
	}
}

- (void)sendNewInput:(id)anInput
{
	//console.log([superController date]);
	//validate the input 
	var newValue = nil;
	
	if([self dateType] == 1){
		newValue = [self numMonthDateInput:anInput];
		[superController date].setMonth(newValue - 1);
	}else if([self dateType] == 2){
		newValue = [self numDayDateInput:anInput];
		[superController date].setDate(newValue);
	}else if([self dateType] == 3){
		newValue = [self fullYearDateInput:anInput];
		[superController date].setFullYear(newValue);
	}else if([self dateType] == 8){
		newValue = [self fullMinutesInput:anInput];
		[superController date].setMinutes(newValue);
	}else if([self dateType] == 9){
		newValue = [self fullHoursInput:anInput];
		var ampm = [[superController segments] objectAtIndex:[[superController segments] count] - 1];
		if([ampm stringValue] === "PM" && newValue !== 12){
		    var hrs = newValue + 12;
		}else if([ampm stringValue] === "AM" && newValue == 12){
		    var hrs = 0;
		}else{
			hrs = newValue;
		}
		[superController date].setHours(hrs);
		
		
	}else if([self dateType] == 10){
		newValue = [self fullAMPMInput:anInput];
		var hours = [[[superController segments] objectAtIndex:0] intValue] - 1;
		if(newValue == "PM"){
			hours = hours + 12;
		}
		
		[superController date].setHours(hours);
		
	}
	
	//for now just update the string value
	[self setStringValue: newValue];
	[[CPNotificationCenter defaultCenter] postNotificationName:"datePickerDidChangeNotification" object:superController userInfo:nil];
}

- (void)makeActive
{
	[self setBackgroundColor:focusedBackground];
	[[superController _theStepper] setDoubleValue:[self intValue]];
}

- (void)makeInactive
{
	[self setBackgroundColor:[CPColor whiteColor]];
	if([self dateType] == 10)
		return;
	//now format the number like it should look...	
	var strValue = [self stringValue];
	if(strValue == 0 && [self dateType] !== 8){ //minutes are allowed to be zero, everything else bust be greater than zero.
		strValue = 1;
	}
	
	if([self dateType] == 1){
		[self setStringValue:[self singleNumber:strValue]];
	}else if([self dateType] == 2){
		[self setStringValue:[self doubleNumber:strValue]];
	}else if([self dateType] == 3){
		[self setStringValue:[self quadNumber:strValue]];
	}else if([self dateType] == 8){
		[self setStringValue:[self doubleNumber:strValue]];
	}else if([self dateType] == 9){
		[self setStringValue:[self singleNumber:strValue]];
	}
}

- (void)increment
{
	if([self dateType] == 10){ // if date segment is AMPM type
		if([self stringValue] == "AM"){
			//[self setStringValue: @"PM"];
			[[superController _theStepper] setDoubleValue:1];
		}else{
			//[self setStringValue: @"AM"];
			[[superController _theStepper] setDoubleValue:0];	
		}
		
	}else{ 
		[[superController _theStepper] setDoubleValue:[self intValue] + 1];
	}
	
	[[superController _theStepper] sendAction:@selector(stepperAction:) to:inputManager];
}

- (void)decrement
{
	if([self dateType] == 10){
		if([self stringValue] == "AM"){
			[self setStringValue: @"PM"];
			[[superController _theStepper] setDoubleValue:1];
		}else{
			[self setStringValue: @"AM"];
			[[superController _theStepper] setDoubleValue:0];
		}
	}else{
		[[superController _theStepper] setDoubleValue:[self intValue] - 1];
	}

	[[superController _theStepper] sendAction:@selector(stepperAction:) to:inputManager];
}

- (void)removeLastChar
{
	var stringValue = [self stringValue];
	if([stringValue length] > 0){
		var newString = [stringValue stringByPaddingToLength:[stringValue length] -1 withString:@"" startingAtIndex:1];
		[self setStringValue: newString];
	}
	
}
@end

@implementation DateSegment (filterData)

- (CPString)numMonthDateInput:(CPString)inputChar
{
	//This takes in the input character and returns a string with the new value for the field...
	var maxMonthValue = [superController maxMonth];
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	
	if([[current stringByAppendingString:newChar] intValue] > maxMonthValue){
	    var returnVal = newChar;
	}else if([[current stringByAppendingString:newChar] intValue] <= maxMonthValue){
	    var returnVal = [current stringByAppendingString:newChar];
	}else{
	    var returnVal = ([newChar intValue]) ? [newChar intValue] : @"";
	}
	
	return [returnVal intValue];
}

- (CPString)numDayDateInput:(CPString)inputChar
{
	//This takes in the input character and returns a string with the new value for the field...
		
	var maxDayValue = [superController maxDays];
	
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	
	if([[current stringByAppendingString:newChar] intValue] > maxDayValue){
	    var returnVal = newChar;
	}else if([[current stringByAppendingString:newChar] intValue] <= maxDayValue ){
	    var returnVal = [current stringByAppendingString:newChar];
	}else{
	    var returnVal = ([newChar intValue]) ? [newChar intValue] : @"";
	}
	
	return [returnVal intValue];
}

- (CPString)fullYearDateInput:(CPString)inputChar
{
	//This takes in the input character and returns a string with the new value for the field...
		
	var maxYearValue = [superController maxYear];
	
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	
	if([[current stringByAppendingString:newChar] intValue] > maxYearValue){
	    var returnVal = newChar;
	}else if([[current stringByAppendingString:newChar] intValue] <= maxYearValue ){
	    var returnVal = [current stringByAppendingString:newChar];
	}else{
	    var returnVal = ([newChar intValue]) ? [newChar intValue] : @"";
	}
	
	return [returnVal intValue];
}

- (CPString)fullMinutesInput:(CPString)inputChar
{
	var maxMinutes = [superController maxMins];
	
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	if([[current stringByAppendingString:newChar] intValue] > maxMinutes){
	    var returnVal = newChar;
	}else if([[current stringByAppendingString:newChar] intValue] <= maxMinutes ){
	    var returnVal = [current stringByAppendingString:newChar];
	}else{
	    var returnVal = ([newChar intValue]) ? [newChar intValue] : @"";
	}
	
	return [returnVal intValue];
}

- (CPString)fullHoursInput:(CPString)inputChar
{
	var maxHours = [superController maxHours];
	
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	if([[current stringByAppendingString:newChar] intValue] > maxHours){
	    var returnVal = newChar;
	}else if([[current stringByAppendingString:newChar] intValue] <= maxHours ){
	    var returnVal = [current stringByAppendingString:newChar];
	}else{
	    var returnVal = ([newChar intValue]) ? [newChar intValue] : @"";
	}
	
	return [returnVal intValue];
}

- (CPString)fullAMPMInput:(CPString)inputChar
{
	var current = [self stringValue];
	var newChar = [inputChar characterAtIndex:0];
	
	if(newChar === "p" || newChar === "P"){
		return "PM";
	}else if(newChar === "a" || newChar === "A"){
		return "AM";
	}else{
		return current;
	}
}

- (CPString)singleNumber:(CPString)aNumber
{
	return aNumber;
}

- (CPString)doubleNumber:(CPString)aNumber
{
	if([aNumber class] === CPNumber){
		var charCount = [[aNumber stringValue] length];
	}else{
		var charCount = [aNumber length];
	}
	
	var prefixed = @"0";
	
	while(charCount < 2){
		var aNumber = [prefixed stringByAppendingString:aNumber];
		charCount++;
	}
	
	return aNumber
}

- (CPString)quadNumber:(CPString)aNumber
{	
	if([aNumber class] === CPNumber){
		var charCount = [[aNumber stringValue] length];
	}else{
		var charCount = [aNumber length];
	}
	
	var prefixed = @"0";
	
	while(charCount < 4){
		var aNumber = [prefixed stringByAppendingString:aNumber];
		charCount++;
	}
	
	return aNumber
}

@end

/*custom input manager*/

@implementation DatePickerInputManager : CPControl
{
	//CPTextField inputManager @accessors;
	id activeDateSegment @accessors;
	id superController @accessors;
}

- (id)init
{
	var aFrame = CGRectMake(0,0,0,0);
	self = [super initWithFrame:aFrame];
	
	return self;
}


@end

@implementation DatePicker (CPCoding)
{
- (id)initWithCoder:(CPCoder)aCoder
{
    self = [super initWithCoder:aCoder];
    
    if (self)
    {
    	
        [self setDelegate:[aCoder decodeObjectForKey:datePickerDelegate]];
        segments = [aCoder decodeObjectForKey:datePickerSegments]
        _theView = [aCoder decodeObjectForKey:datePickerView];
        _theStepper = [aCoder decodeObjectForKey:datePickerStepper];
        [self setDate:[aCoder decodeObjectForKey:datePickerDate]];
        
        [self setNeedsLayout];
        [self setNeedsDisplay:YES];
    }
    
    return self;
}

- (void)encodeWithCoder:(CPCoder)aCoder
{
    // This will come out nil on the other side with decodeObjectForKey:
    [aCoder encodeObject:_date forKey:datePickerDate];
    [aCoder encodeObject:segments forKey:datePickerSegments];
    [aCoder encodeObject:_delegate forKey:dataPickerDelegate];
    [aCoder encodeObject:_theView forKey:datePickerView];
    [aCoder encodeObject:_theStepper forKey:datePickerStepper];
}

}
@end