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

const daoButton = document.getElementById("daoButton");
const daoSection = document.getElementById("dao");

daoButton.onclick = async (e) => {
    e.preventDefault();
    daoButton.setAttribute("disabled", true);

    const data = await actor.getDaoData();
    
    daoSection.innerHTML = 
    `<p><strong>Name:</strong> ${data.name}</p>
    <p><strong>Manifesto:</strong> ${data.manifesto}</p>
    <p><strong>Logo:</strong></p>
        <div>${data.logo}</div>
    <h2>Goals:</h2>
    <table border="1">
        ${data.goals.map(goal => `<tr><td>${goal}</td></tr>`).join("")}
    </table>`;

    daoButton.removeAttribute("disabled");
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