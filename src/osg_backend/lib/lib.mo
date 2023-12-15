module Lib {
    type DaoInfo = {
        manifesto : Text;
    };

    public func initDao() : DaoInfo {
        return { manifesto = "manifesto" };
    };

    public func getManifesto(info : DaoInfo) : Text {
        return info.manifesto;
    };

    public func setManifesto(info : DaoInfo, newManifesto : Text) : DaoInfo {
        return { info with manifesto = newManifesto };
    };
};
