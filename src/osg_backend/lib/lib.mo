import List "mo:base/List";
import Array "mo:base/Array";
import Buffer "mo:base/Buffer";
import Logo "Logo";
module Lib {
    public type List<T> = ?(T, List<T>);
    public type DaoInfo = {
        name : Text;
        manifesto : Text;
        logo : Text;
        goals : List<Text>;
    };

    public func initDao() : DaoInfo {
        return {
            name = "DAO name";
            manifesto = "manifesto";
            logo = Logo.getLogo();
            goals = List.fromArray<Text>([]);
        };
    };

    public func getName(info : DaoInfo) : async Text {
        return info.name;
    };

    public func setName(info : DaoInfo, newName : Text) : DaoInfo {
        return { info with name = newName };
    };

    public func getManifesto(info : DaoInfo) : async Text {
        return info.manifesto;
    };

    public func setManifesto(info : DaoInfo, newManifesto : Text) : DaoInfo {
        return { info with manifesto = newManifesto };
    };

    public func getLogo(info : DaoInfo) : async Text {
        return info.logo;
    };

    public func addGoal(info : DaoInfo, goal : Text) : async DaoInfo {
        return { info with goals = List.push<Text>(goal, info.goals) };
    };

    public func getGoals(info : DaoInfo) : async List<Text> {
        return info.goals;
    };
};
