import React, { Component } from "react";
import { Card, Button } from "semantic-ui-react";
import factory from "../ethereum/factory";
import Layout from "../components/Layout";
import { Link } from "../routes";

class CampaignIndex extends Component {
  static async getInitialProps() {
    const campaigns = await factory.methods.getDeployedCampaigns().call();
    const names = await factory.methods.getCampaigns().call();
    const desc = await factory.methods.getCampaigns1().call();
    const ar = [];
    for (var i = 0; i < names.length; i++) {
      ar.push({ c: campaigns[i], n: names[i], d: desc[i] });
    }
    return { ar };
  }

  renderCampaigns() {
    const items = this.props.ar.map(arr => {
      return {
        header: arr.n,
        meta: arr.d,
        description: (
          <Link route={`/campaigns/${arr.c}`}>
            <a>View Campaign</a>
          </Link>
        ),
        fluid: true
      };
    });

    return <Card.Group items={items} />;
  }

  render() {
    return (
      <Layout>
        <div>
          <h3>Open Campaigns</h3>

          <Link route="/campaigns/new">
            <a>
              <Button
                floated="right"
                content="Create Campaign"
                icon="add circle"
                primary
              />
            </a>
          </Link>

          {this.renderCampaigns()}
        </div>
      </Layout>
    );
  }
}

export default CampaignIndex;
