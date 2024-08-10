import IcpLedger "canister:icp_ledger_canister";
import Debug "mo:base/Debug";
import Result "mo:base/Result";
import Option "mo:base/Option";
import Blob "mo:base/Blob";
import Error "mo:base/Error";
import Array "mo:base/Array";
import Principal "mo:base/Principal";
import Nat64 "mo:base/Nat64";
import Text "mo:base/Text";
import Assets "mo:assets";
import Map "mo:map/Map";
import Map "mo:map/Map";
import { nhash } "mo:map/Map";

actor {

  type Tokens = {
    e8s : Nat64;
  };

  type Donation = {
    account : Text;
    amount : Tokens;
    transaction_id : Nat64;
  };

  type User = {
    created_proposals : [Nat64];
    donated_proposals : [Nat64];
  };

  type Proposal = {
    name : Text;
    title : Text;
    description : Text;
    amount_required : Nat64;
    image : Blob;
    subaccount : Blob;
    created_by : Principal;
    donations : [Donation];
    synced_upto : Nat64;
    amount_raised : Nat64;
  };

  stable let users = Map.new<Principal, User>();
  stable let proposals : [Proposal] = [];

  type TransferArgs = {
    amount : Tokens;
    toPrincipal : Principal;
    oSubaccount : ?Blob;
  };

  public shared ({ caller }) func createProposal(name : Text, title : Text, description : Text, amount_required : Nat64, image : Blob) : async Result.Result<Nat64, Text> {
    if (not Principal.isAnonymous(caller)) {
      let proposal_size = Array.size<Proposal>(proposals);
      let newProposal : Proposal = {
        name = name;
        title = title;
        description = description;
        amount_required = amount_required;
        image = image;
        subaccount : Blob;
        created_by : Principal;
        donations : [Donation];
        synced_upto : Nat64;
        amount_raised : Nat64;
      };
    } else {
      return #err("User Must be Logged In to Create Proposal");
    };
  };

  public shared ({ caller }) func checkPrincipal() : async Text {
    return Principal.toText(caller);
  };

  public shared ({ caller }) func transfer(args : TransferArgs) : async Result.Result<IcpLedger.BlockIndex, Text> {
    Debug.print(
      "Transferring "
      # debug_show (args.amount)
      # " tokens to principal "
      # debug_show (args.toPrincipal)
      # " subaccount "
      # debug_show (args.toSubaccount)
    );

    let transferArgs : IcpLedger.TransferArgs = {
      // can be used to distinguish between transactions
      memo = 0;
      // the amount we want to transfer
      amount = args.amount;
      // the ICP ledger charges 10_000 e8s for a transfer
      fee = { e8s = 10_000 };
      // we are transferring from the canisters default subaccount, therefore we don't need to specify it
      from_subaccount = null;
      // we take the principal and subaccount from the arguments and convert them into an account identifier
      to = Principal.toLedgerAccount(args.toPrincipal, args.toSubaccount);
      // a timestamp indicating when the transaction was created by the caller; if it is not specified by the caller then this is set to the current ICP time
      created_at_time = null;
    };

    try {
      // initiate the transfer
      let transferResult = await IcpLedger.transfer(transferArgs);

      // check if the transfer was successfull
      switch (transferResult) {
        case (#Err(transferError)) {
          return #err("Couldn't transfer funds:\n" # debug_show (transferError));
        };
        case (#Ok(blockIndex)) { return #ok blockIndex };
      };
    } catch (error : Error) {
      // catch any errors that might occur during the transfer
      return #err("Reject message: " # Error.message(error));
    };
  };

  type AccountBalanceArgs = {
    account : IcpLedger.AccountIdentifier;
  };

  public shared ({ caller }) func balance() : async Result.Result<Tokens, Text> {
    let args : AccountBalanceArgs = {
      account = Principal.toLedgerAccount(caller, null);
    };
    let res = await IcpLedger.account_balance(args);
    #ok(res);
  };

};
