/*
 * RLOfflineLocalStorage.j
 * AppKit
 *
 * Created by Randall Luecke.
 * Copyright 20010, Randall Luecke
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@implementation RLOfflineLocalStorage : CPObject
{
    id          _delegate;
}

+ (BOOL)offlineDataStoreIsAvailable
{
    return !!window.localStorage;
}

- (id)initWithName:(CPString)aName delegate:(id)anObject
{
    _delegate = anObject;

    if (![RLOfflineLocalStorage offlineDataStoreIsAvailable] && [_delegate respondsToSelector:@selector(dataStoreIsNotSupported)])
    {
        [_delegate localStorageNotSupported];
        return;
    }

    self = [super init];
    
    return self;
}

- (void)setValue:(CPString)aValue forKey:(CPString)aKey
{
    localStorage.setItem(aKey, aValue);
}

- (CPString)getValueForKey:(CPString)aKey
{
    return localStorage.getItem(aKey);
}

- (void)removeValueForKey:(CPString)aKey
{
    localStorage.removeItem(aKey);

}
@end