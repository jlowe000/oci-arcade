//////////////////////////////////////////////////////////////////////////////////////
// Game

// game modes
var GAME_INVADERS = 0;

var practiceMode = false;
var turboMode = false;

// current game mode
var gameMode = GAME_INVADERS;
var getGameName = (function(){

    var names = ["OCI Invaders"];
    
    return function(mode) {
        if (mode == undefined) {
            mode = gameMode;
        }
        return names[mode];
    };
})();

var getGameDescription = (function(){

    var desc = [
        [
            "DESC 1",
            "DESC 2",
            "DESC 3",
            "",
            "DESC 4",
            "DESC 5",
            "DESC 6",
            "",
            "DESC 7",
            "DESC 8",
        ],
    ];
    
    return function(mode) {
        if (mode == undefined) {
            mode = gameMode;
        }
        return desc[mode];
    };
})();

/*
var getGhostNames = function(mode) {
    if (mode == undefined) {
        mode = gameMode;
    }
    if (mode == GAME_OTTO) {
        return ["plato","darwin","freud","newton"];
    }
    else if (mode == GAME_MSPACMAN) {
        return ["blinky","pinky","inky","sue"];
    }
    else if (mode == GAME_PACMAN) {
        return ["blinky","pinky","inky","clyde"];
    }
    else if (mode == GAME_COOKIE) {
        return ["elmo","piggy","rosita","zoe"];
    }
};

var getGhostDrawFunc = function(mode) {
    if (mode == undefined) {
        mode = gameMode;
    }
    if (mode == GAME_OTTO) {
        return atlas.drawMonsterSprite;
    }
    else if (mode == GAME_COOKIE) {
        return atlas.drawMuppetSprite;
    }
    else {
        return atlas.drawGhostSprite;
    }
};

var getPlayerDrawFunc = function(mode) {
    if (mode == undefined) {
        mode = gameMode;
    }
    if (mode == GAME_OTTO) {
        return atlas.drawOttoSprite;
    }
    else if (mode == GAME_PACMAN) {
        return atlas.drawPacmanSprite;
    }
    else if (mode == GAME_MSPACMAN) {
        return atlas.drawMsPacmanSprite;
    }
    else if (mode == GAME_COOKIE) {
        //return atlas.drawCookiemanSprite;
        return drawCookiemanSprite;
    }
};
*/

// for clearing, backing up, and restoring cheat states (before and after cutscenes presently)
var clearCheats, backupCheats, restoreCheats;
(function(){
    clearCheats = function() {
//        pacman.invincible = false;
//        pacman.ai = false;
//        for (i=0; i<5; i++) {
//            actors[i].isDrawPath = false;
//            actors[i].isDrawTarget = false;
//        }
//        executive.setUpdatesPerSecond(60);
    };

    var i, invincible, ai, isDrawPath, isDrawTarget;
    isDrawPath = {};
    isDrawTarget = {};
    backupCheats = function() {
//        invincible = pacman.invincible;
//        ai = pacman.ai;
//        for (i=0; i<5; i++) {
//            isDrawPath[i] = actors[i].isDrawPath;
//            isDrawTarget[i] = actors[i].isDrawTarget;
//        }
    };
    restoreCheats = function() {
//        pacman.invincible = invincible;
//        pacman.ai = ai;
//        for (i=0; i<5; i++) {
//            actors[i].isDrawPath = isDrawPath[i];
//            actors[i].isDrawTarget = isDrawTarget[i];
//        }
    };
})();

// current level, lives, and score
var level = 1;
var extraLives = 0;

// VCR functions

var savedLevel = {};
var savedExtraLives = {};
var savedHighScore = {};
var savedScore = {};
var savedState = {};

var saveGame = function(t) {
    savedLevel[t] = level;
    savedExtraLives[t] = extraLives;
    savedHighScore[t] = getHighScore();
    savedScore[t] = getScore();
    savedState[t] = state;
};
var loadGame = function(t) {
    level = savedLevel[t];
    if (extraLives != savedExtraLives[t]) {
        extraLives = savedExtraLives[t];
        renderer.drawMap();
    }
    setHighScore(savedHighScore[t]);
    setScore(savedScore[t]);
    state = savedState[t];
};

/// SCORING
// (manages scores and high scores for each game type)

var scores = [
    0
    ];
var highScores = [
    10000
    ];

var getScoreIndex = function() {
    // if (practiceMode) {
    //     return 8;
    // }
    // return gameMode*2 + (turboMode ? 1 : 0);
    return gameMode;
};

// handle a score increment
var addScore = function(p) {

    // get current scores
    var score = getScore();

    // handle extra life at 10000 points
    if (score < 10000 && score+p >= 10000) {
        extraLives++;
        renderer.drawMap();
    }

    score += p;
    setScore(score);

    if (!practiceMode) {
        if (score > getHighScore()) {
            setHighScore(score);
        }
    }
};

var getScore = function() {
    return scores[getScoreIndex()];
};
var setScore = function(score) {
    scores[getScoreIndex()] = score;
};

var getHighScore = function() {
    return highScores[getScoreIndex()];
};
var setHighScore = function(highScore) {
    highScores[getScoreIndex()] = highScore;
    saveHighScores();
};
// High Score Persistence

var loadHighScores = function() {
    var hs;
    var hslen;
    var i;
    if (localStorage && localStorage.highScores) {
        hs = JSON.parse(localStorage.highScores);
        hslen = hs.length;
        for (i=0; i<hslen; i++) {
            highScores[i] = Math.max(highScores[i],hs[i]);
        }
    }
};
var saveHighScores = function() {
    if (localStorage) {
        localStorage.highScores = JSON.stringify(highScores);
    }
};
