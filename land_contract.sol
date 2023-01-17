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
    mapping(address => uint) owned_lands_length;
    mapping(address => Land[]) owned_lands;

    address public owner;

    function land_token() public returns (address)
    {
        owner = msg.sender;
        return owner;
    }

    function add_new_land(address _owner, string memory _location) public {
        require (_owner!=address(0), "Endereço do proprietário não pode ser vazio");
        require (bytes(_location).length > 0, "Localização do terreno não pode ser vazia");

        Land memory new_land = Land(
            {
                ownerAddress: _owner,
                location: _location,
                landID: total_land_tokens
            }
        );
        owned_lands[_owner].push(new_land);
        owned_lands_length[_owner]++;
        total_land_tokens++;
    }

    // Transferir terreno do owner para land_buyer
    function transfer_land(address land_buyer, uint _landID) public returns (bool _result){
        require (owned_lands_length[owner] > 0, "Não possui terrenos para transferir");

        for(uint i=0; i < owned_lands_length[owner]; i++)    
        {
            if (owned_lands[owner][i].landID == _landID){
                owned_lands[owner][i].ownerAddress = land_buyer;
                owned_lands[land_buyer].push(owned_lands[owner][i]);
                owned_lands_length[land_buyer]++;

                if (i < owned_lands_length[owner]){
                    owned_lands[owner][i] = owned_lands[owner][owned_lands_length[owner]-1];
                }

                owned_lands[owner].pop();
                owned_lands_length[owner]--;
                total_land_bought++;

                return true;
            }
        }

        return false;
    }

    function get_my_lands_quantity() public view returns (uint){
        return owned_lands_length[owner];
    }

    function get_land_by_index(uint index) public view returns (string memory, uint){
        require (owned_lands_length[owner] > 0, "Não possui terrenos para visualizar");

        return (owned_lands[owner][index].location, owned_lands[owner][index].landID);
    }
}
