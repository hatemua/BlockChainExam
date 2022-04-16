pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
* @title Staking Token (STK)
* @author Alberto Cuesta Canada
* @notice Implements a basic ERC20 staking token with incentive distribution.
*/
contract TaskBlock  {
   using SafeMath for uint256;
   address owner;
   uint indexEtudiant;
   uint indexExam;
     struct Exam {       
        bool enabled;
        string titre;
        uint questionsNumber;
        uint PercentToPass;
        uint256 date;
        uint maxPassed;
    }
   
    struct PassExam {       
        uint totalAnsYes;
        uint totalAnsNo;
        uint numberPassed;
    }
    struct Etudiant {
        string Name;
        string lastName;
        string Matricule;
    }
    mapping(uint =>  Exam) public Exams;
    mapping(address =>  Etudiant) public Etudiants;
    mapping(uint =>  Etudiant) public EtudiantsT;
    mapping(address =>  mapping (uint => PassExam)) public PassingExam;
    
   
   constructor()
       public 
   {
        owner = msg.sender;

   }
     
   
    modifier onlyOwner
    {
        require(owner == msg.sender);
         _ ;
    }

    function createExam(string memory Titre,uint256 questionsNumber,uint256 PercentToPass,uint256 maximumOfpass)
       public onlyOwner returns (uint)
   {
        
        Exam storage exam = Exams[indexExam];
        exam.titre = Titre;
        exam.questionsNumber = questionsNumber;
        exam.PercentToPass = PercentToPass; 
        exam.date = block.timestamp;
        exam.enabled = true;
        exam.maxPassed = maximumOfpass;
        //ERC20("0x0").approve(address(this), amount);
        //ERC20("0x0").transferFrom(msg.sender, address(this), amount);
        
        indexExam += 1;
        return (indexExam-1);
   }

    function Inscription(string memory Name,string memory lastName,string memory Matricule)
       public  returns (uint)
   {
       Etudiant storage etudiant = Etudiants[msg.sender];
       etudiant.Name = Name;
       etudiant.lastName = lastName;
       etudiant.Matricule = Matricule;
       EtudiantsT[indexEtudiant]= Etudiants[msg.sender];
       indexEtudiant += 1;
       return (indexEtudiant-1);
   }
   
   function PasserExam (uint Exam,uint nbYes,uint nbNo,address Etudiant)
     public onlyOwner returns (bool)
   {
       require(PassingExam[Etudiant][Exam].numberPassed < Exams[Exam].maxPassed,"You have reach the maximum of your chance to pass this exam");
       PassingExam[Etudiant][Exam].numberPassed += 1;
       PassingExam[Etudiant][Exam].totalAnsYes = nbYes;
       PassingExam[Etudiant][Exam].totalAnsNo = nbNo;
       return true;

   }

function PrintPercent (address Etudiant,uint Exam) public view returns (uint)
{
       uint nbYes = PassingExam[Etudiant][Exam].totalAnsYes;
       uint nbQ = Exams[Exam].questionsNumber ;
       uint Percentage = nbYes.mul(100).div(nbQ);
       return (Percentage);

}  
function PrintEtudInscr () public view returns (Etudiant[] memory)
{
    Etudiant[] memory etudiants = new Etudiant[](indexEtudiant);
       for (uint j = 0; j < indexEtudiant; j++) {
      Etudiant storage etudiant = EtudiantsT[j];
          etudiants[j] = etudiant;
      }
       return (etudiants);

} 
function IsCertifate (address Etudiant,uint Exam) public view returns (bool){
        
       uint nbYes = PassingExam[Etudiant][Exam].totalAnsYes;
       uint nbQ = Exams[Exam].questionsNumber ;
       uint Percentage = nbYes.mul(100).div(nbQ);
        if (Percentage >= Exams[Exam].PercentToPass)
        {
            return (true);

        }
        else{
            return (false);
        }
        
        
    }






}




