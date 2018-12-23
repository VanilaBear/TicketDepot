pragma solidity ^0.4.25;

contract TicketDepot {
   struct Event{
        address owner;
        uint64 ticketPrice;
        uint16 ticketsRemaining;
        mapping(uint16 => address) attendees;
    }

   
   uint16 numEvents;
   address owner;
   uint64 transactionFee;
   mapping(uint16 => Event) events;

   function ticketDepot(uint64 _transactionFee) {
       // Конструктор конктракта. Устанавливает transactionFee и owner
       owner = msg.sender;
       transactionFee = _transactionFee;
       numEvents = 0;
   }
   
   function createEvent(uint64 _ticketPrice, uint16 _ticketsAvailable) returns (uint16 eventID) {
       // Создает мероприятие с _ticketsAvailable билетами по цене _ticketPrice, а также устанавливает owner мероприятия
       require(
           _ticketsAvailable > 0,
           "Some tickets are needed."
           );
       
       eventID = numEvents++;
       events[eventID] = Event(owner, _ticketPrice, _ticketsAvailable);
   }
   
   function buyNewTicket(uint16 _eventID, address _attendee) payable returns (uint16 ticketID) {
       // Позволяет купить билет: если послано достаточно денег, чтобы оплатить комиссию владельца контракта + сам билет,
       // то _attendee в attendees соответствующего event. Уменьшает количество доступных билетов.
       // Сразу переводит деньги owner мероприятия.
       require(
            msg.value >= (events[_eventID].ticketPrice + transactionFee),
            "Not enough money."
            );
        require(
            events[_eventID].ticketsRemaining > 0,
            "No more tickets."
            );
        events[_eventID].attendees[ticketID] = _attendee;
        events[_eventID].ticketsRemaining--;
        events[_eventID].owner.transfer(msg.value);
   }


   // ***** Вторая часть задания *****
      struct Offering{
        address buyer;
        uint64 price;
        uint256 deadline;
    }
    mapping(bytes32 => Offering) offerings;   

   function offerTicket(uint16 _eventID, uint16 _ticketID, uint64 _price, address _buyer, uint16 _offerWindow) {
       // Позволяет владельцу билета выставить свой билет на продажу по цене _price в течение _offerWindow блоков
       bytes32 offerID = sha3(_eventID + _ticketID); // Подсказка: рекомендую использовать вот такой offerID
   }

   function buyOfferedTicket(uint16 _eventID, uint16 _ticketID, address _newAttendee) payable {
       // Позволяет купить билет, если продажа еще не закончилась и переведенная сумма достаточная.
       // Обновляет значение attendee, указывая нового вместо старого, а также сразу переводит деньги продавцу
       bytes32 offerID = sha3(_eventID + _ticketID);
   } 
 
}
