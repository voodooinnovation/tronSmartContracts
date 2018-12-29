pragma solidity ^0.4.23;

// File: contracts\lib\BMEvents.sol

/// @title Events used in FomoSport
contract BMEvents {
  
  event onGameCreated(
  uint256 indexed gameID,
  uint256 timestamp
  );
  
  event onGameActivated(
  uint256 indexed gameID,
  uint256 startTime,
  uint256 timestamp
  );
  
  event onGamePaused(
  uint256 indexed gameID,
  bool paused,
  uint256 timestamp
  );
  
  event onChangeCloseTime(
  uint256 indexed gameID,
  uint256 closeTimestamp,
  uint256 timestamp
  );
  
  event onPurchase(
  uint256 indexed gameID,
  uint256 indexed playerID,
  address playerAddress,
  bytes32 playerName,
  uint256 teamID,
  uint256 tronIn,
  uint256 keysBought,
  uint256 timestamp
  );
  
  event onWithdraw(
  uint256 indexed gameID,
  uint256 indexed playerID,
  address playerAddress,
  bytes32 playerName,
  uint256 tronOut,
  uint256 timestamp
  );
  
  event onGameEnded(
  uint256 indexed gameID,
  uint256 winningTeamID,
  string comment,
  uint256 timestamp
  );
  
  event onGameCancelled(
  uint256 indexed gameID,
  string comment,
  uint256 timestamp
  );
  
  event onFundCleared(
  uint256 indexed gameID,
  uint256 fundCleared,
  uint256 timestamp
  );
}

// File: contracts\lib\SafeMath.sol

/// @title SafeMath v0.1.9
/// @dev Math operations with safety checks that throw on error
/// change notes: original SafeMath library from OpenZeppelin modified by Inventor
/// - added sqrt
/// - added sq
/// - added pwr
/// - changed asserts to requires with error log outputs
/// - removed div, its useless
library SafeMath {
  
  /// @dev Multiplies two numbers, throws on overflow.
  function mul(uint256 a, uint256 b)
  internal
  pure
  returns (uint256 c)
  {
    if (a == 0) {
      return 0;
    }
    c = a * b;
    require(c / a == b, "SafeMath mul failed");
    return c;
  }
  
  
  /// @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
  function sub(uint256 a, uint256 b)
  internal
  pure
  returns (uint256)
  {
    require(b <= a, "SafeMath sub failed");
    return a - b;
  }
  
  
  /// @dev Adds two numbers, throws on overflow.
  function add(uint256 a, uint256 b)
  internal
  pure
  returns (uint256 c)
  {
    c = a + b;
    require(c >= a, "SafeMath add failed");
    return c;
  }
  
  
  /// @dev gives square root of given x.
  function sqrt(uint256 x)
  internal
  pure
  returns (uint256 y)
  {
    uint256 z = ((add(x, 1)) / 2);
    y = x;
    while (z < y) {
      y = z;
      z = ((add((x / z), z)) / 2);
    }
  }
  
  
  /// @dev gives square. multiplies x by x
  function sq(uint256 x)
  internal
  pure
  returns (uint256)
  {
    return (mul(x,x));
  }
  
  
  /// @dev x to the power of y
  function pwr(uint256 x, uint256 y)
  internal
  pure
  returns (uint256)
  {
    if (x == 0) {
      return (0);
      } else if (y == 0) {
        return (1);
        } else {
          uint256 z = x;
          for (uint256 i = 1; i < y; i++) {
            z = mul(z,x);
          }
          return (z);
        }
      }
    }
    
    // File: contracts\lib\BMKeyCalc.sol
    
    // key calculation
    library BMKeyCalc {
      using SafeMath for *;
      
      /// @dev calculates number of keys received given X tron
      /// @param _curTron current amount of tron in contract
      /// @param _newTron tron being spent
      /// @return amount of ticket purchased
      function keysRec(uint256 _curTron, uint256 _newTron)
      internal
      pure
      returns (uint256)
      {
        return(keys((_curTron).add(_newTron)).sub(keys(_curTron)));
      }
      
      
      /// @dev calculates amount of tron received if you sold X keys
      /// @param _curKeys current amount of keys that exist
      /// @param _sellKeys amount of keys you wish to sell
      /// @return amount of tron received
      function tronRec(uint256 _curKeys, uint256 _sellKeys)
      internal
      pure
      returns (uint256)
      {
        return((tron(_curKeys)).sub(tron(_curKeys.sub(_sellKeys))));
      }
      
      /// @dev calculates how many keys would exist with given an amount of tron
      /// @param _tron tron "in contract"
      /// @return number of keys that would exist
      function keys(uint256 _tron)
      internal
      pure
      returns(uint256)
      {
        return ((_tron.mul(10000000).add(95062500000000)).sqrt().sub(9750000)).mul(1000000) / (500000);
      }
      
      /// @dev calculates how much tron would be in contract given a number of keys
      /// @param _keys number of keys "in contract"
      /// @return tron that would exists
      function tron(uint256 _keys)
      internal
      pure
      returns(uint256)
      {
        return ((250000).mul((_keys/1000000).sq())).add((9750000).mul(_keys)/1000000);
      }
    }
    
    // File: contracts\lib\BMDatasets.sol
    
    // datasets
    library BMDatasets {
      
      struct Game {
        string name; // game name
        uint256 numberOfTeams; // number of teams
        uint256 gameStartTime; // game start time (> 0 means activated)
        
        bool paused; // game paused
        bool ended; // game ended
        bool canceled; // game canceled
        uint256 winnerTeam; // winner team
        uint256 withdrawDeadline; // deadline for withdraw fund
        string gameEndComment; // comment for game ending or canceling
        uint256 closeTime; // betting close time
      }
      
      struct GameStatus {
        uint256 totalTron; // total tron invested
        uint256 totalWithdrawn; // total withdrawn by players
        uint256 winningVaultInst; // current "instant" winning vault
        uint256 winningVaultFinal; // current "final" winning vault
        bool fundCleared; // fund already cleared
      }
      
      struct Team {
        bytes32 name; // team name
        uint256 keys; // number of keys
        uint256 tron; // total tron for the team
        uint256 mask; // mask of this team
        uint256 dust; // dust for winning vault
      }
      
      struct Player {
        uint256 tron; // total tron for the game
        bool withdrawn; // winnings already withdrawn
      }
      
      struct PlayerTeam {
        uint256 keys; // number of keys
        uint256 tron; // total tron for the team
        uint256 mask; // mask for this team
      }
    }
    
    // File: contracts\lib\Ownable.sol
    
    /**
    * @title Ownable
    * @dev The Ownable contract has an owner address, and provides basic authorization control
    * functions, this simplifies the implementation of "user permissions".
    */
    contract Ownable {
      address public owner;
      address public dev;
      
      /**
      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
      * account.
      */
      constructor() public {
        owner = msg.sender;
      }
      
      
      /**
      * @dev Throws if called by any account other than the owner.
      */
      modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
      }
      
      /**
      * @dev Throws if called by any account other than the dev.
      */
      modifier onlyDev() {
        require(msg.sender == dev, "only dev");
        _;
      }
      
      /**
      * @dev Throws if called by any account other than the owner or dev.
      */
      modifier onlyDevOrOwner() {
        require(msg.sender == owner || msg.sender == dev, "only owner or dev");
        _;
      }
      
      /**
      * @dev Allows the current owner to transfer control of the contract to a newOwner.
      * @param newOwner The address to transfer ownership to.
      */
      function transferOwnership(address newOwner) onlyOwner public {
        if (newOwner != address(0)) {
          owner = newOwner;
        }
      }
      
      /**
      * @dev Allows the current owner to set a new dev address.
      * @param newDev The new dev address.
      */
      function setDev(address newDev) onlyOwner public {
        if (newDev != address(0)) {
          dev = newDev;
        }
      }
    }
    
    // File: contracts\interface\BMForwarderInterface.sol
    
    interface BMForwarderInterface {
      function deposit() external payable;
    }
    
    // File: contracts\interface\BMPlayerBookInterface.sol
    
    interface BMPlayerBookInterface {
      function pIDxAddr_(address _addr) external returns (uint256);
      function pIDxName_(bytes32 _name) external returns (uint256);
      
      function getPlayerID(address _addr) external returns (uint256);
      function getPlayerName(uint256 _pID) external view returns (bytes32);
      function getPlayerLAff(uint256 _pID) external view returns (uint256);
      function setPlayerLAff(uint256 _pID, uint256 _lAff) external;
      function getPlayerAffT2(uint256 _pID) external view returns (uint256);
      function getPlayerAddr(uint256 _pID) external view returns (address);
      function getPlayerHasAff(uint256 _pID) external view returns (bool);
      function getNameFee() external view returns (uint256);
      function getAffiliateFee() external view returns (uint256);
      function depositAffiliate(uint256 _pID) external payable;
    }
    
    // File: contracts\BMSport.sol
    
    /// @title A raffle system for sports betting, designed with FOMO elements
    /// @notice This contract manages multiple games. Owner(s) can create games and
    /// assign winning team for each game. Players can withdraw their winnings before
    /// the deadline set by the owner(s). If there's no winning team, the owner(s)
    /// can also cancel a game so the players get back their bettings (minus fees).
    /// @dev The address of the forwarder, player book, and owner(s) are hardcoded.
    /// Check 'TODO' before deploy.
    contract BMSport is BMEvents, Ownable {
      using BMKeyCalc for *;
      using SafeMath for *;
      
      // TODO: check address!!
      BMForwarderInterface private Banker_Address;
      BMPlayerBookInterface private BMBook;
      
      string constant public name_ = "BMSport";
      uint256 public gameIDIndex_;
      
      // (gameID => gameData)
      mapping(uint256 => BMDatasets.Game) public game_;
      
      // (gameID => gameStatus)
      mapping(uint256 => BMDatasets.GameStatus) public gameStatus_;
      
      // (gameID => (teamID => teamData))
      mapping(uint256 => mapping(uint256 => BMDatasets.Team)) public teams_;
      
      // (playerID => (gameID => playerData))
      mapping(uint256 => mapping(uint256 => BMDatasets.Player)) public players_;
      
      // (playerID => (gameID => (teamID => playerTeamData)))
      mapping(uint256 => mapping(uint256 => mapping(uint256 => BMDatasets.PlayerTeam))) public playerTeams_;
      
      
      constructor(BMPlayerBookInterface book_addr) public {
        require(book_addr != address(0), "need a playerbook address");
        BMBook = book_addr;
        gameIDIndex_ = 1;
      }
      
      
      /// @notice Create a game. Only owner(s) can call this function.
      /// Emits "onGameCreated" event.
      /// @param _name Name of the new game.
      /// @param _teamNames Array consisting names of all teams in the game.
      /// The size of the array indicates the number of teams in this game.
      /// @return Game ID of the newly created game.
      function createGame(string _name, bytes32[] _teamNames)
      external
      isHuman()
      onlyDevOrOwner()
      returns(uint256)
      {
        uint256 _gameID = gameIDIndex_;
        gameIDIndex_++;
        
        // initialize game
        game_[_gameID].name = _name;
        
        // initialize each team
        uint256 _nt = _teamNames.length;
        require(_nt > 0, "number of teams must be larger than 0");
        
        game_[_gameID].numberOfTeams = _nt;
        for (uint256 i = 0; i < _nt; i++) {
          teams_[_gameID][i] = BMDatasets.Team(_teamNames[i], 0, 0, 0, 0);
        }
        
        emit onGameCreated(_gameID, now);
        
        return _gameID;
      }
      
      
      /// @notice Activate a game. Only owner(s) can do this.
      /// Players can start buying keys after start time.
      /// Emits "onGameActivated" event.
      /// @param _gameID Game ID of the game.
      /// @param _startTime Timestamp of the start time.
      function activate(uint256 _gameID, uint256 _startTime)
      external
      isHuman()
      onlyDevOrOwner()
      {
        require(_gameID < gameIDIndex_, "incorrect game id");
        require(game_[_gameID].gameStartTime == 0, "already activated");
        
        // TODO: do some initialization
        game_[_gameID].gameStartTime = _startTime;
        
        emit onGameActivated(_gameID, _startTime, now);
      }
      
      
      /// @notice Buy keys for each team.
      /// Emits "onPurchase" for each team with a purchase.
      /// @param _gameID Game ID of the game to buy tickets.
      /// @param _teamTron Array consisting amount of TRON for each team to buy tickets.
      /// The size of the array must be the same as the number of teams.
      /// The paid TRON along with this function call must be the same as the sum of all
      /// TRON in this array.
      function buysXid(uint256 _gameID, uint256[] memory _teamTron)
      public
      payable
      isActivated(_gameID)
      isOngoing(_gameID)
      isNotPaused(_gameID)
      isNotClosed(_gameID)
      isHuman()
      isWithinLimits(msg.value)
      {
        // fetch player id
        uint256 _pID = BMBook.getPlayerID(msg.sender);
        
        // purchase keys for each team
        buysCore(_gameID, _pID, _teamTron);
      }
      
      
      /// @notice Pause a game. Only owner(s) can do this.
      /// Players can't buy tickets if a game is paused.
      /// Emits "onGamePaused" event.
      /// @param _gameID Game ID of the game.
      /// @param _paused "true" to pause this game, "false" to unpause.
      function pauseGame(uint256 _gameID, bool _paused)
      external
      isActivated(_gameID)
      isOngoing(_gameID)
      onlyDevOrOwner()
      {
        game_[_gameID].paused = _paused;
        
        emit onGamePaused(_gameID, _paused, now);
      }
      
      
      /// @notice Set a closing time for betting. Only owner(s) can do this.
      /// Players can't buy tickets for this game once the closing time is passed.
      /// Emits "onChangeCloseTime" event.
      /// @param _gameID Game ID of the game.
      /// @param _closeTime Timestamp of the closing time.
      function setCloseTime(uint256 _gameID, uint256 _closeTime)
      external
      isActivated(_gameID)
      isOngoing(_gameID)
      onlyDevOrOwner()
      {
        game_[_gameID].closeTime = _closeTime;
        
        emit onChangeCloseTime(_gameID, _closeTime, now);
      }
      
      
      /// @notice Select a winning team. Only owner(s) can do this.
      /// Players can't no longer buy tickets for this game once a winning team is selected.
      /// Players who bought tickets for the winning team are able to withdraw winnings.
      /// Emits "onGameEnded" event.
      /// @param _gameID Game ID of the game.
      /// @param _team Team ID of the winning team.
      /// @param _comment A closing comment to describe the conclusion of the game.
      /// @param _deadline Timestamp of the withdraw deadline of the game
      function settleGame(uint256 _gameID, uint256 _team, string _comment, uint256 _deadline)
      external
      isActivated(_gameID)
      isOngoing(_gameID)
      isValidTeam(_gameID, _team)
      onlyDevOrOwner()
      {
        // TODO: check deadline limit
        require(_deadline >= now + 86400, "deadline must be more than one day later.");
        
        game_[_gameID].ended = true;
        game_[_gameID].winnerTeam = _team;
        game_[_gameID].gameEndComment = _comment;
        game_[_gameID].withdrawDeadline = _deadline;
        
        if (teams_[_gameID][_team].keys == 0) {
          // no one bought winning keys, send pot to community
          uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
          gameStatus_[_gameID].totalWithdrawn = _totalPot;
          if (_totalPot > 0) {
            Banker_Address.deposit.value(_totalPot)();
          }
        }
        
        emit BMEvents.onGameEnded(_gameID, _team, _comment, now);
      }
      
      
      /// @notice Cancel a game. Only owner(s) can do this.
      /// Players can't no longer buy tickets for this game once a winning team is selected.
      /// Players who bought tickets can get back 95% of the TRON paid.
      /// Emits "onGameCancelled" event.
      /// @param _gameID Game ID of the game.
      /// @param _comment A closing comment to describe the conclusion of the game.
      /// @param _deadline Timestamp of the withdraw deadline of the game
      function cancelGame(uint256 _gameID, string _comment, uint256 _deadline)
      external
      isActivated(_gameID)
      isOngoing(_gameID)
      onlyDevOrOwner()
      {
        // TODO: check deadline limit
        require(_deadline >= now + 86400, "deadline must be more than one day later.");
        
        game_[_gameID].ended = true;
        game_[_gameID].canceled = true;
        game_[_gameID].gameEndComment = _comment;
        game_[_gameID].withdrawDeadline = _deadline;
        
        emit BMEvents.onGameCancelled(_gameID, _comment, now);
      }
      
      
      /// @notice Withdraw winnings. Only available after a game is ended
      /// (winning team selected or game canceled).
      /// Emits "onWithdraw" event.
      /// @param _gameID Game ID of the game.
      function withdraw(uint256 _gameID)
      external
      isHuman()
      isActivated(_gameID)
      isEnded(_gameID)
      {
        require(now < game_[_gameID].withdrawDeadline, "withdraw deadline already passed");
        require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
        
        uint256 _pID = BMBook.pIDxAddr_(msg.sender);
        
        require(_pID != 0, "player has not played this game");
        require(players_[_pID][_gameID].withdrawn == false, "player already cashed out");
        
        players_[_pID][_gameID].withdrawn = true;
        
        if (game_[_gameID].canceled) {
          // game is canceled
          // withdraw 95% of the original payments
          uint256 _totalInvestment = players_[_pID][_gameID].tron.mul(95) / 100;
          if (_totalInvestment > 0) {
            // send to player
            BMBook.getPlayerAddr(_pID).transfer(_totalInvestment);
            gameStatus_[_gameID].totalWithdrawn = _totalInvestment.add(gameStatus_[_gameID].totalWithdrawn);
          }
          
          emit BMEvents.onWithdraw(_gameID, _pID, msg.sender, BMBook.getPlayerName(_pID), _totalInvestment, now);
          } else {
            uint256 _totalWinnings = getPlayerInstWinning(_gameID, _pID, game_[_gameID].winnerTeam).add(getPlayerPotWinning(_gameID, _pID, game_[_gameID].winnerTeam));
            if (_totalWinnings > 0) {
              // send to player
              BMBook.getPlayerAddr(_pID).transfer(_totalWinnings);
              gameStatus_[_gameID].totalWithdrawn = _totalWinnings.add(gameStatus_[_gameID].totalWithdrawn);
            }
            
            emit BMEvents.onWithdraw(_gameID, _pID, msg.sender, BMBook.getPlayerName(_pID), _totalWinnings, now);
          }
        }
        
        
        /// @notice Clear funds of a game. Only owner(s) can do this, after withdraw deadline
        /// is passed.
        /// Emits "onFundCleared" event.
        /// @param _gameID Game ID of the game.
        function clearFund(uint256 _gameID)
        external
        isHuman()
        isEnded(_gameID)
        onlyDevOrOwner()
        {
          require(now >= game_[_gameID].withdrawDeadline, "withdraw deadline not passed yet");
          require(gameStatus_[_gameID].fundCleared == false, "fund already cleared");
          
          gameStatus_[_gameID].fundCleared = true;
          
          // send remaining fund to community
          uint256 _totalPot = (gameStatus_[_gameID].winningVaultInst).add(gameStatus_[_gameID].winningVaultFinal);
          uint256 _amount = _totalPot.sub(gameStatus_[_gameID].totalWithdrawn);
          if (_amount > 0) {
            Banker_Address.deposit.value(_amount)();
          }
          
          emit onFundCleared(_gameID, _amount, now);
        }
        
        
        /// @notice Get a player's current instant pot winnings.
        /// @param _gameID Game ID of the game.
        /// @param _pID Player ID of the player.
        /// @param _team Team ID of the team.
        /// @return Instant pot winnings of the player for this game and this team.
        function getPlayerInstWinning(uint256 _gameID, uint256 _pID, uint256 _team)
        public
        view
        isActivated(_gameID)
        isValidTeam(_gameID, _team)
        returns(uint256)
        {
          return ((((teams_[_gameID][_team].mask).mul(playerTeams_[_pID][_gameID][_team].keys)) / (1000000)).sub(playerTeams_[_pID][_gameID][_team].mask));
        }
        
        
        /// @notice Get a player's current final pot winnings.
        /// @param _gameID Game ID of the game.
        /// @param _pID Player ID of the player.
        /// @param _team Team ID of the team.
        /// @return Final pot winnings of the player for this game and this team.
        function getPlayerPotWinning(uint256 _gameID, uint256 _pID, uint256 _team)
        public
        view
        isActivated(_gameID)
        isValidTeam(_gameID, _team)
        returns(uint256)
        {
          if (teams_[_gameID][_team].keys > 0) {
            return gameStatus_[_gameID].winningVaultFinal.mul(playerTeams_[_pID][_gameID][_team].keys) / teams_[_gameID][_team].keys;
            } else {
              return 0;
            }
          }
          
          
          /// @notice Get current game status.
          /// @param _gameID Game ID of the game.
          /// @return (number of teams, names, keys, tron, current key price for 1 key)
          function getGameStatus(uint256 _gameID)
          public
          view
          isActivated(_gameID)
          returns(uint256, bytes32[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
          {
            uint256 _nt = game_[_gameID].numberOfTeams;
            bytes32[] memory _names = new bytes32[](_nt);
            uint256[] memory _keys = new uint256[](_nt);
            uint256[] memory _tron = new uint256[](_nt);
            uint256[] memory _keyPrice = new uint256[](_nt);
            uint256 i;
            
            for (i = 0; i < _nt; i++) {
              _names[i] = teams_[_gameID][i].name;
              _keys[i] = teams_[_gameID][i].keys;
              _tron[i] = teams_[_gameID][i].tron;
              _keyPrice[i] = getBuyPrice(_gameID, i, 1000000);
            }
            
            return (_nt, _names, _keys, _tron, _keyPrice);
          }
          
          
          /// @notice Get player status of a game.
          /// @param _gameID Game ID of the game.
          /// @param _pID Player ID of the player.
          /// @return (name, tron for each team, keys for each team, inst win for each team, pot win for each team)
          function getPlayerStatus(uint256 _gameID, uint256 _pID)
          public
          view
          isActivated(_gameID)
          returns(bytes32, uint256[] memory, uint256[] memory, uint256[] memory, uint256[] memory)
          {
            uint256 _nt = game_[_gameID].numberOfTeams;
            uint256[] memory _tron = new uint256[](_nt);
            uint256[] memory _keys = new uint256[](_nt);
            uint256[] memory _instWin = new uint256[](_nt);
            uint256[] memory _potWin = new uint256[](_nt);
            uint256 i;
            
            for (i = 0; i < _nt; i++) {
              _tron[i] = playerTeams_[_pID][_gameID][i].tron;
              _keys[i] = playerTeams_[_pID][_gameID][i].keys;
              _instWin[i] = getPlayerInstWinning(_gameID, _pID, i);
              _potWin[i] = getPlayerPotWinning(_gameID, _pID, i);
            }
            
            return (BMBook.getPlayerName(_pID), _tron, _keys, _instWin, _potWin);
          }
          
          
          /// @notice Get the price buyer have to pay for next keys.
          /// @param _gameID Game ID of the game.
          /// @param _team Team ID of the team.
          /// @param _keys Number of keys (in wei).
          /// @return Price for the number of keys to buy (in wei).
          function getBuyPrice(uint256 _gameID, uint256 _team, uint256 _keys)
          public
          view
          isActivated(_gameID)
          isValidTeam(_gameID, _team)
          returns(uint256)
          {
            return ((teams_[_gameID][_team].keys.add(_keys)).tronRec(_keys));
          }
          
          
          /// @notice Get the prices buyer have to pay for next keys for all teams.
          /// @param _gameID Game ID of the game.
          /// @param _keys Array of number of keys (in wei) for all teams.
          /// @return (total tron, array of prices in wei).
          function getBuyPrices(uint256 _gameID, uint256[] memory _keys)
          public
          view
          isActivated(_gameID)
          returns(uint256, uint256[])
          {
            uint256 _totalTron = 0;
            uint256 _nt = game_[_gameID].numberOfTeams;
            uint256[] memory _tron = new uint256[](_nt);
            uint256 i;
            
            require(_nt == _keys.length, "Incorrect number of teams");
            
            for (i = 0; i < _nt; i++) {
              if (_keys[i] > 0) {
                _tron[i] = getBuyPrice(_gameID, i, _keys[i]);
                _totalTron = _totalTron.add(_tron[i]);
              }
            }
            
            return (_totalTron, _tron);
          }
          
          
          /// @notice Get the number of keys can be bought with an amount of TRON.
          /// @param _gameID Game ID of the game.
          /// @param _team Team ID of the team.
          /// @param _tron Amount of TRON in wei.
          /// @return Number of keys can be bought (in wei).
          function getKeysfromTRON(uint256 _gameID, uint256 _team, uint256 _tron)
          public
          view
          isActivated(_gameID)
          isValidTeam(_gameID, _team)
          returns(uint256)
          {
            return (teams_[_gameID][_team].tron).keysRec(_tron);
          }
          
          
          /// @notice Get all numbers of keys can be bought with amounts of TRON.
          /// @param _gameID Game ID of the game.
          /// @param _trons Array of amounts of TRON in wei.
          /// @return (total keys, array of number of keys in wei).
          function getKeysFromTRONs(uint256 _gameID, uint256[] memory _trons)
          public
          view
          isActivated(_gameID)
          returns(uint256, uint256[])
          {
            uint256 _totalKeys = 0;
            uint256 _nt = game_[_gameID].numberOfTeams;
            uint256[] memory _keys = new uint256[](_nt);
            uint256 i;
            
            require(_nt == _trons.length, "Incorrect number of teams");
            
            for (i = 0; i < _nt; i++) {
              if (_trons[i] > 0) {
                _keys[i] = getKeysfromTRON(_gameID, i, _trons[i]);
                _totalKeys = _totalKeys.add(_keys[i]);
              }
            }
            
            return (_totalKeys, _keys);
          }
          
          /// @dev Buy keys for all teams.
          /// @param _gameID Game ID of the game.
          /// @param _pID Player ID of the player.
          /// @param _teamTron Array of tron paid for each team.
          function buysCore(uint256 _gameID, uint256 _pID, uint256[] memory _teamTron)
          private
          {
            uint256 _nt = game_[_gameID].numberOfTeams;
            uint256[] memory _keys = new uint256[](_nt);
            bytes32 _name = BMBook.getPlayerName(_pID);
            uint256 _totalTron = 0;
            uint256 i;
            
            require(_teamTron.length == _nt, "Number of teams is not correct");
            
            // for all teams...
            for (i = 0; i < _nt; i++) {
              if (_teamTron[i] > 0) {
                // compute total tron
                _totalTron = _totalTron.add(_teamTron[i]);
                
                // compute number of keys to buy
                _keys[i] = (teams_[_gameID][i].tron).keysRec(_teamTron[i]);
                
                // update player data
                playerTeams_[_pID][_gameID][i].tron = _teamTron[i].add(playerTeams_[_pID][_gameID][i].tron);
                playerTeams_[_pID][_gameID][i].keys = _keys[i].add(playerTeams_[_pID][_gameID][i].keys);
                
                // update team data
                teams_[_gameID][i].tron = _teamTron[i].add(teams_[_gameID][i].tron);
                teams_[_gameID][i].keys = _keys[i].add(teams_[_gameID][i].keys);
                
                emit BMEvents.onPurchase(_gameID, _pID, msg.sender, _name, i, _teamTron[i], _keys[i], now);
              }
            }
            
            // check assigned TRON for each team is the same as msg.value
            require(_totalTron == msg.value, "Total TRON is not the same as msg.value");
            
            // update game data and player data
            gameStatus_[_gameID].totalTron = _totalTron.add(gameStatus_[_gameID].totalTron);
            players_[_pID][_gameID].tron = _totalTron.add(players_[_pID][_gameID].tron);
            
            distributeAll(_gameID, _pID, _totalTron, _keys);
          }
          
          
          /// @dev Distribute paid TRON to different pots.
          /// @param _gameID Game ID of the game.
          /// @param _pID Player ID of the player.
          /// @param _totalTron Total TRON paid.
          /// @param _keys Array of keys bought for each team.
          function distributeAll(uint256 _gameID, uint256 _pID, uint256 _totalTron, uint256[] memory _keys)
          private
          {
            // community 5%
            uint256 _com = _totalTron / 20;
            
            // instant pot (15%)
            uint256 _instPot = _totalTron.mul(15) / 100;
            
            // winning pot (80%)
            uint256 _pot = _totalTron.mul(80) / 100;
            
            // Send community to forwarder
            
            Banker_Address.deposit.value(_com)();
            
            gameStatus_[_gameID].winningVaultInst = _instPot.add(gameStatus_[_gameID].winningVaultInst);
            gameStatus_[_gameID].winningVaultFinal = _pot.add(gameStatus_[_gameID].winningVaultFinal);
            
            // update masks for instant winning vault
            uint256 _nt = _keys.length;
            for (uint256 i = 0; i < _nt; i++) {
              uint256 _newPot = _instPot.add(teams_[_gameID][i].dust);
              uint256 _dust = updateMasks(_gameID, _pID, i, _newPot, _keys[i]);
              teams_[_gameID][i].dust = _dust;
            }
          }
          
          
          /// @dev Updates masks for instant pot.
          /// @param _gameID Game ID of the game.
          /// @param _pID Player ID of the player.
          /// @param _team Team ID of the team.
          /// @param _gen Amount of TRON to be added into instant pot.
          /// @param _keys Number of keys bought.
          /// @return Dust left over.
          function updateMasks(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _gen, uint256 _keys)
          private
          returns(uint256)
          {
            /* MASKING NOTES
            earnings masks are a tricky thing for people to wrap their minds around.
            the basic thing to understand here. is were going to have a global
            tracker based on profit per share for each round, that increases in
            relevant proportion to the increase in share supply.
            
            the player will have an additional mask that basically says "based
            on the rounds mask, my shares, and how much i've already withdrawn,
            how much is still owed to me?"
            */
            
            // calc profit per key & round mask based on this buy: (dust goes to pot)
            if (teams_[_gameID][_team].keys > 0) {
              uint256 _ppt = (_gen.mul(1000000)) / (teams_[_gameID][_team].keys);
              teams_[_gameID][_team].mask = _ppt.add(teams_[_gameID][_team].mask);
              
              updatePlayerMask(_gameID, _pID, _team, _ppt, _keys);
              
              // calculate & return dust
              return(_gen.sub((_ppt.mul(teams_[_gameID][_team].keys)) / (1000000)));
              } else {
                return _gen;
              }
            }
            
            
            /// @dev Updates masks for the player.
            /// @param _gameID Game ID of the game.
            /// @param _pID Player ID of the player.
            /// @param _team Team ID of the team.
            /// @param _ppt Amount of unit TRON.
            /// @param _keys Number of keys bought.
            /// @return Dust left over.
            function updatePlayerMask(uint256 _gameID, uint256 _pID, uint256 _team, uint256 _ppt, uint256 _keys)
            private
            {
              if (_keys > 0) {
                // calculate player earning from their own buy (only based on the keys
                // they just bought). & update player earnings mask
                uint256 _pearn = (_ppt.mul(_keys)) / (1000000);
                playerTeams_[_pID][_gameID][_team].mask = (((teams_[_gameID][_team].mask.mul(_keys)) / (1000000)).sub(_pearn)).add(playerTeams_[_pID][_gameID][_team].mask);
              }
            }
            
            /**
            * @dev Allows the current owner to transfer Banker_Address to a new banker.
            * @param banker The address to transfer Banker_Address to.
            */
            function transferBanker(BMForwarderInterface banker)
            public
            onlyOwner()
            {
              if (banker != address(0)) {
                Banker_Address = banker;
              }
            }
            
            
            /// @dev Check if a game is activated.
            /// @param _gameID Game ID of the game.
            modifier isActivated(uint256 _gameID) {
              require(game_[_gameID].gameStartTime > 0, "Not activated yet");
              require(game_[_gameID].gameStartTime <= now, "game not started yet");
              _;
            }
            
            
            /// @dev Check if a game is not paused.
            /// @param _gameID Game ID of the game.
            modifier isNotPaused(uint256 _gameID) {
              require(game_[_gameID].paused == false, "game is paused");
              _;
            }
            
            
            /// @dev Check if a game is not closed.
            /// @param _gameID Game ID of the game.
            modifier isNotClosed(uint256 _gameID) {
              require(game_[_gameID].closeTime == 0 || game_[_gameID].closeTime > now, "game is closed");
              _;
            }
            
            
            /// @dev Check if a game is not settled.
            /// @param _gameID Game ID of the game.
            modifier isOngoing(uint256 _gameID) {
              require(game_[_gameID].ended == false, "game is ended");
              _;
            }
            
            
            /// @dev Check if a game is settled.
            /// @param _gameID Game ID of the game.
            modifier isEnded(uint256 _gameID) {
              require(game_[_gameID].ended == true, "game is not ended");
              _;
            }
            
            
            /// @dev Check if caller is not a smart contract.
            modifier isHuman() {
              address _addr = msg.sender;
              require (_addr == tx.origin, "Human only");
              
              uint256 _codeLength;
            assembly { _codeLength := extcodesize(_addr) }
            require(_codeLength == 0, "Human only");
            _;
          }
          
          
          /// @dev Check if purchase is within limits.
          /// (between 1 TRON and 100000000000000000 TRON)
          /// @param _tron Amount of TRON
          modifier isWithinLimits(uint256 _tron) {
            require(_tron >= 10000000, "too little money");
            require(_tron <= 100000000000000000000000, "too much money");
            _;
          }
          
          
          /// @dev Check if team ID is valid.
          /// @param _gameID Game ID of the game.
          /// @param _team Team ID of the team.
          modifier isValidTeam(uint256 _gameID, uint256 _team) {
            require(_team < game_[_gameID].numberOfTeams, "there is no such team");
            _;
          }
        }
        