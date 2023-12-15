import {
    createActor,
    osg_backend,
} from "../../declarations/osg_backend";
import { AuthClient } from "@dfinity/auth-client";
import { HttpAgent } from "@dfinity/agent";

let actor = osg_backend;
console.log(`ii=${process.env.CANISTER_ID_INTERNET_IDENTITY}`);
const whoAmIButton = document.getElementById("whoAmI");
whoAmIButton.onclick = async (e) => {
    e.preventDefault();
    whoAmIButton.setAttribute("disabled", true);
    const principal = await actor.whoami();
    whoAmIButton.removeAttribute("disabled");
    document.getElementById("principal").innerText = principal.toString();
    return false;
};

const emptyRequest = {
    body: new Uint8Array(),
    headers: [],
    method: '',
    url: '',
  };

const daoButton = document.getElementById("daoButton");
daoButton.onclick = async (e) => {
    e.preventDefault();
    daoButton.setAttribute("disabled", true);
    const webpage = await actor.dao_webpage(emptyRequest);
    const webpageText = new TextDecoder().decode(webpage.body);
    const newTab = window.open('DAO');
    newTab.document.write(webpageText); 
    daoButton.removeAttribute("disabled");
    // document.getElementById("dao").innerText = "<goto DAO tab>";
    return false;
};

const openSourceGardensButton = document.getElementById("openSourceGardensButton");
openSourceGardensButton.onclick = (e) => {
    e.preventDefault();
    window.open('https://5xuw3-ciaaa-aaaam-ab2ka-cai.icp0.io/', 'Open Source Gardens');
    return false;
};

const loginButton = document.getElementById("login");
loginButton.onclick = async (e) => {
    e.preventDefault();
    let authClient = await AuthClient.create();
    // start the login process and wait for it to finish
    await new Promise((resolve) => {
        authClient.login({
            identityProvider:
                process.env.DFX_NETWORK === "ic"
                    ? "https://identity.ic0.app"
                    : `http://localhost:4943/?canisterId=${process.env.CANISTER_ID_INTERNET_IDENTITY}`,
            onSuccess: resolve,
        });
    });
    const identity = authClient.getIdentity();
    const agent = new HttpAgent({ identity });
    actor = createActor(process.env.CANISTER_ID_OSG_BACKEND, {
        agent,
    });
    return false;
};



