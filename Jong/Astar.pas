unit Astar;    // Recherche de chemin

// The TAStarCell and TAStarList classes were provided by NeoDelphi.
// The corresponding algorithm has been modified for this purpose.
// The procedure names have therefore been changed to avoid confusion.

interface

uses Windows, SysUtils, Classes, Graphics, ExtCtrls, Controls, Dialogs,
     Jong;


type
  // Data from a cell for calculating the shortest path
  // We use a class to make it easier to work with
  // pointers and to allow the cell to point to its parent.
  // The parent is very important because it's what allows us to trace the
  // path once the algorithm is finished.
  TAStarCell = class
    position: TPoint;
    costfrom: integer;
    costto: integer;
    cost: integer;
    parent: TAStarCell;
    llprevious: TAStarCell;
    llnext: TAStarCell;

    constructor Create;
    procedure calcCost;
  end;

  // Stack to obtain the list of cells for calculating the shortest path.
  // The data is stored as a linked list.
  TAStarList = class
    first: TAStarCell;
    last: TAStarCell;

    constructor Create;
    procedure add(element: TAStarCell);
    procedure del(element: TAStarCell);
    procedure clear;
    function get(position: TPoint ): TAStarCell;
    function getSmaller: TAStarCell;
    function isFree: boolean;
  end;

var
  depart : TPoint;
  but : TPoint;
  lesCases : TAStarList;    // open list
  leChemin : TAStarList;    // closed list
  macase : TAStarcell;
  propos : TPoint;
  cout : integer;
  nbca : integer;
  route,
  chemin : array of Tpoint;

const nbCasesX = 10;
      nbCasesY = 10;

procedure TracePt(tp : TPoint);
procedure RecUtiles;
function CheminOk(dep,arv : TPoint) : boolean;
procedure AjouteCase(parent: TAStarCell; position: TPoint);

implementation

procedure Trace(tp : TPoint);
begin
  with tp do
    Showmessage(inttostr(tablo[x,y]));
end;

procedure TracePt(tp : TPoint);
begin
  with tp do
    Showmessage(inttostr(X)+' - '+inttostr(Y)+' - '+inttostr(tablo[x,y]));
end;

// Retrieving useful data: position and cost
procedure RecUtiles;
var
  i,n : integer;
begin
  nbca := 1;
  SetLength(chemin,nbca);
  chemin[0] := but;
  cout := leChemin.last.costfrom + 1;
  macase := leChemin.last;
  while macase.parent <> nil do
  begin
    propos := depart;   // we store the position before
    depart := macase.position; // to acquire the new
    inc(nbca);
    SetLength(chemin,nbca);
    chemin[nbca-1] := depart;           
    macase := macase.parent;
  end;
end;

//******************************************************************************
// Beginning of the shortest path search algorithm
//******************************************************************************
function CheminOk(dep,arv : TPoint) : boolean;
var
  curcell: TAStarCell;
  nextcell: TAStarCell;
  stop: boolean;
begin
  Result := false;
  depart := dep;
  but := arv;
  // We delete the lists
  lesCases.clear();
  leChemin.clear();
  // We create the starting cell
  curcell := TAStarCell.Create;
  curcell.position := depart;
  curcell.calcCost();
  // We add the starting cell to the closed list
  leChemin.add(curcell);
  // Until we reach the finish line or the open list
  // It's not empty, we continue to search.
  stop := false;
  while stop = false do
  begin
    // The search is performed starting from the current cell.
    AjouteCase(curcell, Point(curcell.position.X, curcell.position.Y-1));
    AjouteCase(curcell, Point(curcell.position.X, curcell.position.Y+1));
    AjouteCase(curcell, Point(curcell.position.X-1, curcell.position.Y));
    AjouteCase(curcell, Point(curcell.position.X+1, curcell.position.Y));
    // We are looking for the next cell from which the search was performed:
    // the one with the lowest cost.
    // If the open list is empty, it's not possible, and that means there is no
    // no journey possible.
    if not lesCases.isFree() then
    begin
      nextcell := lesCases.getSmaller();
      // If we've arrived, we stop.
      // This test must be done before removing the current cell from the open list.
      if (nextcell.position.Y = but.Y) and (nextcell.position.X = but.X) then
      begin
        stop := true;
        RecUtiles;
        Result := true;
      end
      else
        begin
        // We remove the next item from the open list and add it to the closed list.
          lesCases.del(nextcell);
          leChemin.add(nextcell);
        // We put the next cell in curlell.
          curcell := nextcell;
       end;
    end
    else
      stop := true;
  end;
end;

//******************************************************************************
// Adds the cell if it is not already in the open list and returns
// the price of the journey.
//******************************************************************************
procedure AjouteCase(parent: TAStarCell; position: TPoint);
var
  cell: TAStarCell;
  tmpcell: TAStarCell;
begin                    // tracept(position);
  // We check that the cell does not go off the map and that we do not fall
  // not on a wall
  // The cell must also not be in the closed list.
  if (position.X >= 0) and (position.X < nbCasesX)
  and(position.Y >= 0) and (position.Y < nbCasesY)
  and(tablo[position.X, position.Y] < 0)
  and(leChemin.get(position) = nil) then
  begin
    // We retrieve the cell
    cell := lesCases.get(position);
    // If the cell is not already in the open list
    if cell = nil then
    begin
      cell := TAStarCell.Create;
      cell.position := position;
      // We use the parent cell to know which cell we came from.
      cell.parent := parent;
       // We calculate the price
      cell.calcCost();
       // On ajoute la cellule à la liste ouverte
      lesCases.add(cell);
    end
    else
    // If the cell is already in the list:
    // We create a temporary cell at the same position and calculate the cost.
    // If this cost is lower, it means we found a shorter path to reach the
    //same cell, and we will therefore modify the cell's data to take the new
    //path into account: we change the parent and the cost.
       begin
         tmpcell := TAStarCell.Create;
         tmpcell.position := position;
         tmpcell.parent := parent;
         tmpcell.calcCost;
         if tmpcell.costfrom < cell.costfrom then
         begin
           cell.parent := parent;
           cell.calcCost();
         end;
         tmpcell.Free;
       end;
  end;
end; 

//******************************************************************************
// Manufacturer AStarCell.
// Initializes linked list pointers to nil, i.e., they point to nothing.
//******************************************************************************
constructor TAStarCell.Create();
begin
  parent := nil;
  llprevious := nil;
  llnext := nil;
end;

//******************************************************************************
// Calculating the travel cost
//******************************************************************************
procedure TAStarCell.calcCost();
begin
  // The price to come is the price to come for the parent + 1
  if parent<>nil then costfrom := parent.costfrom + 1
  else costfrom := 0;
  // The price to go there is an approximate calculation that does not take into account
  // the map data.
  // Here is the distance of the shortest path if there are no walls.
  costto := abs( but.Y - position.Y )+ abs(but.X - position.X);
  cost := costfrom + costto;
end;

//******************************************************************************
// Manufacturer of the TAStarList.
// We initialize the pointers to the first and last elements to nil.
//******************************************************************************
constructor TAStarList.Create();
begin
  first := nil;
  last := nil;
end;

//******************************************************************************
// Adding an element passed as a parameter to the linked list.
//******************************************************************************
procedure TAStarList.add(element: TAStarCell);
begin
  // If the linked list is not empty
  if first <> nil then
  begin
    // We point the last element to the new one
    last.llnext := element;
    // We make the new element point to the last one
    element.llprevious := last;
    // The following elements are not included.
    element.llnext := nil;
    // We make last point to element
    last := element;
  end
  else
    begin
      // The element is both the first and the last
      first := element;
      last := element;
    end;
end;

//******************************************************************************
// Remove the element from the linked list
//******************************************************************************
procedure TAStarList.del(element: TAStarCell);
begin
  // We check if there is an element before
  if element.llprevious <> nil then
  begin
    // We make the next one of the previous one point to the next one of the current one (uh?!)
    element.llprevious.llnext := element.llnext;
  end
  else
  // Otherwise, it's the first element.
    begin
      first := element.llnext;
    end;

  // We check if the element has a following element
  if element.llnext <> nil then
  begin
    element.llnext.llprevious := element.llprevious;
  end
  else
    begin
      last := element.llprevious;
   end;
end;

//******************************************************************************
// Returns the cell based on its position; returns nil if it does not exist.
//******************************************************************************
function TAStarList.get(position: TPoint): TAStarCell;
var
  _result: TAStarCell;
  current: TAStarCell;
begin
  // By default the result is nil
  _result := nil;
  current := first;
  // We point the current to the first element of the list
  while (_result = nil) and (current <> nil) do
  begin
    // We check if the cell's position matches the requested one.
    if (current.position.X = position.X) and (current.position.Y = position.Y) then
    begin
      _result := current;
    end
    else
      begin
        // If the cell is not the one we are looking for, we move on to the next one.
        current := current.llnext;
      end;
    end;
  // We return the result
  get := _result;
end;

//******************************************************************************
// Returns the cell with the lowest cost.
// To find the shortest path, look at the list starting with the last element
// (the one that was just added).
//******************************************************************************
function TAStarList.getSmaller(): TAStarCell;
var
  smaller: integer;
  smaller_cell: TAStarCell;
  current: TAStarCell;
begin
  smaller := -1;
  smaller_cell := nil;
  current := last;
  // We point the current to the first element of the list
  while (current <> nil) do
  begin
    if (current.cost < smaller) or (smaller = -1) then
    begin
      smaller := current.cost;
      smaller_cell := current;
    end;
    current := current.llprevious;
  end;
  // We return the result
  getSmaller := smaller_cell;
end;

//******************************************************************************
// Returns true if the list is empty
//******************************************************************************
function TAStarList.isFree(): boolean;
begin
  isFree := first = nil;
end;

//******************************************************************************
// Clears the list, freeing up memory for each AStarCell
//******************************************************************************
procedure TAStarList.clear();
var
  current: TAStarCell;
  next: TAStarCell;
begin
  current := first;
  while current<>nil do
  begin
    next := current.llnext;
    current.Free;
    current := next;
  end;
  first := nil;
  last := nil;
end;

end.
