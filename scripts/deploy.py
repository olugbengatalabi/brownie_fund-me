from brownie import FundMe, network, config, MockV3Aggregator
from web3 import Web3
from scripts.helpful_scripts import get_account, deploy_mocks, LOCAL_BLOCKCHAIN_ENVIRONMENTS


def deploy_fund_me():
  account = get_account()
  if network.show_active() not in LOCAL_BLOCKCHAIN_ENVIRONMENTS:
    print("test")
    price_feed_address = config["networks"][network.show_active()]["eth_usd_price_feed"]
    print(price_feed_address)
  else:
    deploy_mocks()
    price_feed_address = MockV3Aggregator[-1].address
  
    print(config["networks"][network.show_active()][0] + "ffala")
  # pass the price feed
  fund_me = FundMe.deploy(
    price_feed_address,
    {"from": account},
    publish_source=False
    )
  print(f"contract deployed to {fund_me.address}")
  return fund_me
  
def main():
  deploy_fund_me()