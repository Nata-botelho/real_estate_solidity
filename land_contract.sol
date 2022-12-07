// Version of compiler
pragma solidity ^0.5.0;

contract land_token 
{

    // Imprimindo o número total de terrenos que foram comprados por investidores
    uint public total_land_bought = 0;
    uint public total_land_tokens = 0;

    // Estrutura de dados que representa o terreno
    struct Land 
    {
        address ownerAddress;
        string location;
        uint landID;
    }

    // Mapeamento do endereço do investidor para seu patrimônio em terrenos (land tokens)
    mapping(address => uint) owned_lands_quantity;
    mapping(address => Land[]) owned_lands;

    address public owner = msg.sender;

    function add_new_land(address _owner, string memory _location) public {
        Land memory new_land = Land(
            {
                ownerAddress: _owner,
                location: _location,
                landID: total_land_tokens
            }
        );
        owned_lands[_owner].push(new_land);
        total_land_tokens++;
    }

    // Transferir terreno do owner para land_buyer
    function transfer_land(address land_buyer, uint _landID) public returns (bool _result){
        for(uint i=0; i < (owned_lands[owner].length); i++)    
        {
            if (owned_lands[owner][i].landID == _landID){
                owned_lands[owner][i].ownerAddress = land_buyer;
                owned_lands[land_buyer].push(owned_lands[owner][i]);
                owned_lands_quantity[land_buyer]++;

                if (i < owned_lands_quantity[owner]){
                    owned_lands[owner][i] = owned_lands[owner][owned_lands_quantity[owner]-1];
                }

                owned_lands[owner].pop();
                owned_lands_quantity[owner]--;

                total_land_bought++;

                return true;
            }
        }

        return false;
    }
}
