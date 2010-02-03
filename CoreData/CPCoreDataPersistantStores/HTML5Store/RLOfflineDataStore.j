/*
 * RLOfflineDataStore.j
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

@implementation RLOfflineDataStore : CPObject
{
    CPString    _name;
    double      _size;
    id          _db;
    id          _delegate;
}

+ (BOOL)offlineDataStoreIsAvailable
{
    return !!window.openDatabase
}

- (id)initWithName:(CPString)aName delegate:(id)anObject
{
    _delegate = anObject;

    if (![RLOfflineDataStore offlineDataStoreIsAvailable] && [_delegate respondsToSelector:@selector(dataStoreIsNotSupported)])
    {
        [_delegate dataStoreIsNotSupported];
        return;
    }

    self = [super init];
    if (self)
    {
        _name = aName;
        _size = 1024 * 2000;
        
        _db = openDatabase('RCOfflineDataStore-' + _name, '1.0', _name, _size);

        if(!_db && [_delegate respondsToSelector:@selector(userDidRejectDatabase)])
        {
            [_delegate userDidRejectDatabase];
            return;
        }
        else if(!_db)
        {
            [CPException exceptionWithName:@"RLOfflineDataStore" reason:@"Offline storage was rejected by the user." userInfo:nil];
            return;
        }

        _db.transaction(function(_db){
                _db.executeSql( 'CREATE TABLE IF NOT EXISTS RLOfflineDataStore (key TEXT UNIQUE NOT NULL PRIMARY KEY, value TEXT NOT NULL)' );
        });
    }
    return self;
}

- (void)setValue:(CPString)aValue forKey:(CPString)aKey
{
    //there is probably a better way to do this
    _db.transaction(function(db){
        //if the key exists update it, if not it will fail quietly.
        db.executeSql("UPDATE RLOfflineDataStore SET value = ? WHERE key = ?",[aValue, aKey], function result(tx, rs){}, function anError(tx, err){});
        //if the key exists this will fail quietyl, if not it will add the key to the db.
        db.executeSql("INSERT INTO RLOfflineDataStore (key, value) VALUES (?, ?)", [aKey, aValue], function result(db, rs){}, function error(db, err){});
    });

    
}

- (id)storedValueForKey:(CPString) aKey
{
	var resultObject = "test";
	_db.transaction(function(db){
        db.executeSql("SELECT value FROM RLOfflineDataStore WHERE key=?",[aKey], function result(text, result)
		{
			resultObject = [self _parseResultsDirectly:result]; 
		}, 
		function anError(text, theError){});
    });

	return resultObject;
}

- (id)_parseResultsDirectly:(id)results
{
    if(results.rows.length > 0)
        var returnValue = results.rows.item(0).value;
    else
        var returnValue = nil;

   return returnValue;
}

- (void)getValueForKey:(CPString)aKey
{
    _db.transaction(function(db){
        db.executeSql("SELECT value FROM RLOfflineDataStore WHERE key=?",[aKey], function result(text, result){[self _parseResults:result]; [[CPRunLoop currentRunLoop] limitDateForMode:nil]}, function anError(text, theError){});
    });
}

- (void)removeValueForKey:(CPString)aKey
{
    _db.transaction(function(db){
        db.executeSql("DELETE FROM RLOfflineDataStore WHERE key=?",[aKey], function result(text, result){}, function anError(text, theError){});
    });

}

- (void)_parseResults:(id)results
{
    if(results.rows.length > 0)
        var returnValue = results.rows.item(0).value;
    else
        var returnValue = nil;

    [_delegate didReciveData:returnValue];
}

@end