from brownie import FundMe
from scripts.helpful_scripts import get_account


def fund():
  fund_me = FundMe[-1]
  account = get_account()
  entrance_fee = fund_me.getEntranceFee()
  print(f"the current entry fee is {entrance_fee}")
  print("funding")
  price = fund_me.getPrice()
  print(f"the current price of ETH is {price}")
  efee = fund_me.getConversionRate(entrance_fee)
  print(efee)
  fund_me.fund({"from":account, "value":entrance_fee})
  # fund_me.fund({"from":account, "value":entrance_fee})
  
def withdraw():
  fund_me = FundMe[-1]
  account = get_account()
  fund_me.withdraw({"from":account})
  
  
def main():
  fund()
  withdraw()