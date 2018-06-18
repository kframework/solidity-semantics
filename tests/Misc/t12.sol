contract InfoFeed {
    function info() returns (uint ret) { return 42; }
}

contract Consumer {
    InfoFeed feed;
    function setFeed(address addr) { feed = InfoFeed(addr); } 
    
    function callFeed() { feed.info.value(10).gas(800)(); }
}