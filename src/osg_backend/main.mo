import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Http "lib/http";
import Logo "lib/Logo";
import Lib "lib/lib";

actor {
    public type List<T> = ?(T, List<T>);

    // Define a name for you DAO
    let name : Text = "GardenVille";

    // get name
    public query func getName() : async Text {
        return name;
    };

    // let theDao = Lib.initDao();
    let theDao = Lib.setManifesto(Lib.initDao(), "Gardening Community of the Future");

    // list of goals
    var goals : List<Text> = null;

    public func addGoal(goal : Text) : async () {
        goals := List.push<Text>(goal, goals);
    };

    public query func getGoals() : async [Text] {
        List.toArray<Text>(goals);
    };

    type Member = {
        name : Text;
        age : Nat;
    };

    type Result<A, B> = Result.Result<A, B>;
    type HashMap<K, V> = HashMap.HashMap<K, V>;

    var members : HashMap<Principal, Member> = HashMap.HashMap<Principal, Member>(100, Principal.equal, Principal.hash);

    public shared (msg) func addMember(member : Member) : async Result<(), Text> {
        let caller = msg.caller;
        switch (members.get(caller)) {
            case null {
                members.put(caller, member);
                return #ok(());
            };
            case _ {
                return #err("Caller is already a member");
            };
        };
    };

    public shared query func getMember(principal : Principal) : async Result<Member, Text> {
        switch (members.get(principal)) {
            case (?member) {
                return #ok(member);
            };
            case null {
                return #err("No member found for the given principal");
            };
        };
    };

    public shared (msg) func updateMember(member : Member) : async Result<(), Text> {
        let caller = msg.caller;
        switch (members.get(caller)) {
            case (?_) {
                members.put(caller, member);
                return #ok(());
            };
            case null {
                return #err("Caller is not a member");
            };
        };
    };

    public shared query func getAllMembers() : async [Member] {
        let res = Buffer.Buffer<Member>(members.size());
        for (m in members.vals()) {
            res.add(m);
        };
        return Buffer.toArray(res);
    };

    public shared query func numberOfMembers() : async Nat {
        return members.size();
    };

    public shared (msg) func removeMember(principal : Principal) : async Result<(), Text> {
        switch (members.get(msg.caller)) {
            case (?_) {
                ignore members.remove(msg.caller);
                return #ok(());
            };
            case _ {
                return #err("Caller is not a member");
            };
        };
    };


    public query (message) func whoami() : async Text {
        return "Hello, " # Principal.toText(message.caller) # " !";
    };

    func _getWebpage() : Text {
        var webpage = "<style>" #
        "body { text-align: center; font-family: Arial, sans-serif; background-color: #f0f8ff; color: #333; }" #
        "h1 { font-size: 3em; margin-bottom: 10px; }" #
        "hr { margin-top: 20px; margin-bottom: 20px; }" #
        "em { font-style: italic; display: block; margin-bottom: 20px; }" #
        "ul { list-style-type: none; padding: 0; }" #
        "li { margin: 10px 0; }" #
        "li:before { content: '👉 '; }" #
        "svg { max-width: 150px; height: auto; display: block; margin: 20px auto; }" #
        "h2 { text-decoration: underline; }" #
        "</style>";

        let theManifesto: Text = Lib.getManifesto(theDao);
        let logo : Text = Logo.getLogo();

        webpage := webpage # "<div><h1>" # name # "</h1></div>";
        webpage := webpage # "<em>" # theManifesto # "</em>";
        webpage := webpage # "<div>" # logo # "</div>";
        webpage := webpage # "<hr>";
        webpage := webpage # "<h2>Our goals:</h2>";
        webpage := webpage # "<ul>";
        for (goal in Iter.fromList(goals)) {
            webpage := webpage # "<li>" # goal # "</li>";
        };
        webpage := webpage # "</ul>";
        return webpage;
    };

    public query func dao_webpage(request : Http.Request) : async Http.Response {

        let page = _getWebpage();
        let response = {
            body = Text.encodeUtf8(page);
            // body = Text.encodeUtf8("Hello world");
            headers = [("Content-Type", "text/html; charset=UTF-8")];
            status_code = 200 : Nat16;
            streaming_strategy = null;
        };
        return (response);
    };
};
