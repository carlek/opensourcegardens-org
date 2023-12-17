import Principal "mo:base/Principal";
import Text "mo:base/Text";
import Result "mo:base/Result";
import HashMap "mo:base/HashMap";
import Buffer "mo:base/Buffer";
import List "mo:base/List";
import Iter "mo:base/Iter";
import Array "mo:base/Array";
import Http "lib/http";
import Logo "lib/Logo";
import Lib "lib/lib";

actor {
    public type List<T> = ?(T, List<T>);

    // Define a name for you DAO
    let daoName : Text = "GardenVille DAO";

    // get name
    public query func getDaoName() : async Text {
        return daoName;
    };

    var theDao = Lib.initDao();
    theDao := Lib.setManifesto(theDao, "Gardening Community of the Future");
    theDao := Lib.setName(theDao, "GardenVille DAO");

    public func addGoal(goal : Text) : async () {
        theDao := await Lib.addGoal(theDao, goal);
        return ();
    };

    public func getGoals() : async [Text] {
        let goalsList = await Lib.getGoals(theDao);
        return List.toArray(goalsList);
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
                return #err(
                    "Caller " #
                    Principal.toText(caller) #
                    " is already a member"
                );
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

    type DaoData = {
        name: Text;
        manifesto: Text;
        logo: Text;
        goals: [Text];
    };
    public func getDaoData() : async DaoData {
        let name = await Lib.getName(theDao);
        let theManifesto : Text = await Lib.getManifesto(theDao);
        let logo : Text = await Lib.getLogo(theDao);
        let goalsList = await Lib.getGoals(theDao);

        let data = {
            name: Text = name;
            manifesto: Text = theManifesto;
            logo: Text = logo;
            goals: [Text] = List.toArray(goalsList);
        };
        return (data);
    };

};
