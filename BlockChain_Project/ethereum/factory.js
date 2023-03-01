import web3 from "./web3";
import CampaignFactory from "./build/CampaignFactory.json";

const instance = new web3.eth.Contract(
  JSON.parse(CampaignFactory.interface),
  "0xFedddEEff1cDB7a606029CdFcA5dd9d1670B41BE"
);

export default instance;
