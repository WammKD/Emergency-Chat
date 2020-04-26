function openDB(tableName) {
  // var dB = LocalStorage.openDatabaseSync(identifier,
                                         // version,
                                         // description,
                                         // estimated_size,
                                         // callback(db));
  var dB = LocalStorage.openDatabaseSync("emergencychat",
                                         "1.0",
                                         "Non-verbal communication aid.",
                                         100000);

  try {
    dB.transaction(function(tx) {
                     tx.executeSql('CREATE TABLE IF NOT EXISTS '        +
                                   'settings(splash INTEGER NOT NULL, ' +
                                            'switch BOOLEAN NOT NULL);');
                     tx.executeSql('CREATE TABLE IF NOT EXISTS '                                       +
                                   'splashes(id         INTEGER PRIMARY KEY AUTOINCREMENT DEFAULT 1, ' +
                                            'is_current BOOLEAN NOT NULL, '                            +
                                            'title      TEXT    NOT NULL, '                            +
                                            'blurb      TEXT    NOT NULL);');

                     if(tx.executeSql("SELECT * "        +
                                      "FROM   settings;").rows.length == 0) {
                       tx.executeSql('INSERT INTO settings VALUES(?, ?);',
                                     [4, 1]);

                       print('Settings table seeded.');
                     }
                     print('Settings table initialized.');

                     if(tx.executeSql("SELECT * "        +
                                      "FROM   splashes;").rows.length == 0) {
                       tx.executeSql('INSERT INTO splashes VALUES(?, ?, ?, ?);',
                                     [null,
																			1,
                                      "Autistic Meltdown",
                                      "I gave you my phone because I can't use " +
                                      "or process speech right now but I am "    +
                                      "still capable of text communication."     +
                                      "\n\n"                                     +
                                      "My hearing and tactile senses are "       +
                                      "extremely sensitive in this state so "    +
                                      "please refrain from touching me. Please " +
                                      "keep calm and proceed to the next "       +
                                      "screen that has a simple chat client "    +
                                      "through which we can communicate."]);

                       print('Splashes table seeded.');
                     }
                     print('Splashes table initialized.');
                   });

    return dB;
  } catch(err) {
    print("Error creating table in database: " + err);
  }
}


/**
 * Settings functions
 */
function getSettingsValue(col) {
  var r = "";

  try {
    db.transaction(function(tx) {
                     r = tx.executeSql("SELECT * "        +
                                       "FROM   settings;").rows.item(0)[col];
                   });
  } catch(err) {
    print("Error retrieving value from database: " + err);
  }

  return r;
}

function updateSettingsValue(col, value) {
  try {
    db.transaction(function(tx) {  // There should only be one row, all times
                     tx.executeSql('UPDATE settings '     +
                                   'SET   ' + col + '=?;', [value]);
                   });
  } catch(err) {
    print("Error updating value in database.")
    print('Command sent was: UPDATE settings SET ' +
          col + '=\'' + value + '\';');
    print(err);
  }
}


/**
 * Splashes functions
 */
function getCurrentSplashValue(valueName) {
  var r = "";

  try {
    db.transaction(function(tx) {
                     r = tx.executeSql("SELECT * "              +
                                       "FROM   splashes "       +
                                       "WHERE  is_current = 1;")
                           .rows
                           .item(0)[valueName];
                   });
  } catch(err) {
    print("Error retrieving splash value from database: " + err);
  }

  return r;
}

function getCurrentSplashID() {
  return getCurrentSplashValue('id');
}

function getCurrentSplashTitle() {
  return getCurrentSplashValue('title');
}

function getCurrentSplashBlurb() {
  return getCurrentSplashValue('blurb');
}

function getSplashes() {
  var r = [];

  try {
    db.transaction(function(tx) {
                     r = tx.executeSql("SELECT * "        +
                                       "FROM   splashes;").rows;
                   });
  } catch(err) {
    print("Error retrieving all splashes from database: " + err);
  }

  return r;
}

function insertSplash(title, blurb) {
  try {
    db.transaction(function(tx) {
                     tx.executeSql('INSERT INTO splashes VALUES(?, ?, ?, ?);',
																	 [null, 0, title, blurb]);
                   });
  } catch(err) {
    print("Error inserting value in database.")
    print('Command sent was: INSERT INTO splashes ' +
					'VALUES(null, 0, ' + title + ', ' + blurb + ');');
    print(err);
  }
}

function updateSplashValue(id, col, value) {
  try {
    db.transaction(function(tx) {
                     tx.executeSql('UPDATE splashes '     +
                                   'SET   ' + col + '=? ' +
																	 'WHERE  id=?;',         [value, id]);
                   });
  } catch(err) {
    print("Error updating value in database.")
    print('Command sent was: UPDATE splashes SET ' +
          col + '=\'' + value + '\' '              +
					'id=' + id + ';');
    print(err);
  }
}

function deleteSplash(id) {
  try {
    db.transaction(function(tx) {
                     tx.executeSql('DELETE FROM splashes WHERE id=?;', [id]);
                   });
  } catch(err) {
    print("Error deleting value in database.")
    print('Command sent was: DELETE FROM splashes ' +
					'WHERE id=' + id + ';');
    print(err);
  }
}
