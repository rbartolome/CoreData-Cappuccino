@import <AppKit/CPControl.j>
@import <AppKit/CPButton.j>

@implementation Stepper : CPControl
{
	CPButton	_upButton;
	CPButton	_bottomButton;
	CPView		_splitter;
	
	double 	_minValue;
	double 	_maxValue;
	double 	_increment;
	BOOL	_valueWraps;
	BOOL	_autorepeat;
}

-(id)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
	
	if(self){
		[self setMaxValue:59.0];
		[self setMinValue:0.0];
		[self setIncrement:1.0];
		[self setAutorepeat:YES];
		[self setValueWraps:YES];
		[self setDoubleValue:0.0];
		
		
		_upButton = [[CPButton alloc] initWithFrame:		CGRectMake(0.0, 0.0,  12.0, 10.0)];
		_bottomButton = [[CPButton alloc] initWithFrame:	CGRectMake(0.0, 11.0, 12.0, 12.0)];
		_splitter = [[CPView alloc] initWithFrame:			CGRectMake(0.0, 10.0, 12.0, 1.0)];
		
		[_upButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Stepper/stepper_up.png" size:CGSizeMake(12.0, 10.0)]];
		[_bottomButton setImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Stepper/stepper_down.png" size:CGSizeMake(12.0, 12.0)]];
		[_splitter setBackgroundColor:[[CPColor alloc] _initWithPatternImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Stepper/stepper_middle.png" size:CGSizeMake(12.0, 1.0)]]];
		
		[_upButton setAlternateImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Stepper/stepper_up_highlighted.png" size:CGSizeMake(12.0, 10.0)]];
		[_bottomButton setAlternateImage:[[CPImage alloc] initWithContentsOfFile:@"Resources/Stepper/stepper_down_highlighted.png" size:CGSizeMake(12.0, 12.0)]];
		
		[_upButton setBordered:NO];
		[_bottomButton setBordered:NO];
		
		[_upButton setTarget:self];
		[_bottomButton setTarget:self];
		
		
		[_upButton setContinuous:YES];
		[_bottomButton setContinuous:YES];
		
		[_upButton setAction:@selector(buttonUpAction:)];
		[_bottomButton setAction:@selector(buttonDownAction:)];
		
		[self addSubview:_upButton];
		[self addSubview:_splitter];
		[self addSubview:_bottomButton];
		
		
	}
	
	return self;
}

- (double)minValue
{
	return _minValue;
}

- (void)setMinValue:(double)minValue
{
	_minValue = minValue; 
}

- (double)maxValue
{
	return _maxValue;
}
- (void)setMaxValue:(double)maxValue
{
	_maxValue = maxValue;
}

- (double)increment
{
	return _increment;
}

- (void)setIncrement:(double)increment
{
	_increment = increment;
}

- (BOOL)valueWraps
{
	return _valueWraps;
}

- (void)setValueWraps:(BOOL)valueWraps
{
	_valueWraps = valueWraps
}

- (BOOL)autorepeat
{
	return _autorepeat
}

- (void)setAutorepeat:(BOOL)autorepeat
{
	_autorepeat = autorepeat;
}

/*button actions*/
-(void)buttonUpAction:(id)sender
{
	if(([self doubleValue] + [self increment]) > [self maxValue]){
		if([self valueWraps]){
			[self setDoubleValue:[self minValue]];
		}
	}else{
		[self setDoubleValue: [self doubleValue] + [self increment]];
	}
	[self sendAction:[self action] to:[self target]]; 
}

-(void)buttonDownAction:(id)sender
{
	if(([self doubleValue] - [self increment]) < [self minValue]){
		if([self valueWraps]){
			[self setDoubleValue:[self maxValue]];
		}
	}else{
		[self setDoubleValue: [self doubleValue] - [self increment]];
	}
		//console.log([self doubleValue]);
	[self sendAction:[self action] to:[self target]]; 
}
