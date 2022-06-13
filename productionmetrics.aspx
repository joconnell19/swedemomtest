<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ViewItems.aspx.cs" Inherits="Hub.ViewItems" MasterPageFile="~/Site.Master" %>


<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">

     <style>

        .pagination>li>span 

        {

            font-weight: bold;

            font-size: 16px;

        }

        
        
        .container

        {

            

        }


        #adminTools{

            border-top:1px solid #e5e5e5;

            padding-top: 2em;

        }

    </style>

    <script src="../scripts/bsPaging.js"></script>

    <script>

        function imgError(image) {

            image.onerror = "";

            image.src = "../images/placeholder.png";

            return true;

        }

        $(document).ready(function () {

            $("#MainContent_mainTable_ResultPager").NETtoBSPaging();

        });


        function copyTextToClipboard(text) {

            var textArea = document.createElement("textarea");


            //

            // *** This styling is an extra step which is likely not required. ***

            //

            // Why is it here? To ensure:

            // 1. the element is able to have focus and selection.

            // 2. if element was to flash render it has minimal visual impact.

            // 3. less flakyness with selection and copying which **might** occur if

            //    the textarea element is not visible.


            // Place in top-left corner of screen regardless of scroll position.

            textArea.style.position = 'fixed';

            textArea.style.top = 0;

            textArea.style.left = 0;

            // Ensure it has a small width and height. Setting to 1px / 1em

            // doesn't work as this gives a negative w/h on some browsers.

            textArea.style.width = '2em';

            textArea.style.height = '2em';

            // We don't need padding, reducing the size if it does flash render.

            textArea.style.padding = 0;

            // Clean up any borders.

            textArea.style.border = 'none';

            textArea.style.outline = 'none';

            textArea.style.boxShadow = 'none';

            // Avoid flash of white box if rendered for any reason.

            textArea.style.background = 'transparent';



            textArea.value = text;

            document.body.appendChild(textArea);

            textArea.focus();

            textArea.select();

            try {

                var successful = document.execCommand('copy');

                var msg = successful ? 'successful' : 'unsuccessful';

                console.log('Copying text command was ' + msg);

            } catch (err) {

                console.log('Oops, unable to copy');

            }


            document.body.removeChild(textArea);

        }


        function getSelectedParts() {

            var partIDs = new Array;

            $(".select_partnumber:checkbox:checked").each(function (index) {

                console.log(index + ": " + $(this).val());


                //add parts to an array

                partIDs.push($(this).val());

                $(this).attr("checked", false);

                $("#select_" + $(this).val()).css("background-color", "green");

            });

            return partIDs;

        }

        function copyParts() {

            var output = getSelectedParts().toString();

            copyTextToClipboard(output);//copy to clipboard

        }

        function redirectToNewBinSheetWithSelected() {

            var output = getSelectedParts().toString();

            var url = "<%=HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/")%>" + "Account/SingleBinSheet?sheetID=1&autoCreate=1&items=" + output;

            window.open(url, '_blank'); 

        }


        function addToSheet() {

            var output = getSelectedParts().toString();

            var url = "<%=HttpContext.Current.Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/")%>" + "Account/SingleBinSheet?sheetID=" + $("#binSheetID").val() + "&items=" + output;

            console.log(url);

            window.open(url, '_blank'); 

        }

    </script>



    <h2>Viewing Your Items</h2>

    <%if ((isInternalAdmin()||pnp.Items.Count>6) && !Page.IsPostBack)

        { %>

        <div class="alert alert-warning" id="tooManyItemsToLoad">

           Please select an item status to load items

        </div>

    <%} %>

    <br />

    <div align="center">

        <div class="form-inline">

            <div class="form-group" id="prefixContainer" runat="server">

                <label for="pnp">Prefix: </label>

                <asp:DropDownList ID="pnp" runat="server" CssClass="form-control"></asp:DropDownList>

            </div>

            <div class="form-group">

                <label for="statusID">Status: </label>

                 <asp:DropDownList ID="statusID" runat="server" CssClass="form-control"></asp:DropDownList>

            </div>

            <div class="form-group">

                <label for="statusID">Keywords: </label>

                 <asp:TextBox ID="keywords" runat="server" CssClass="form-control"></asp:TextBox>

            </div>

            <br /><br />

            <div class="form-group">

                <label for="statusID">Items per Page: </label>

                 <asp:DropDownList ID="itemsPerPage" runat="server" CssClass="form-control"></asp:DropDownList>

            </div>

            <asp:Button ID="btnFilter" runat="server" CssClass="btn btn-default" 

                Text="Filter" onclick="btnFilter_Click" />

        </div>


        <%if (isInternalAdmin() && Page.IsPostBack)

        { %>

        <br />

         <div id="adminTools">

            <label>Admin Tools: </label>

            <div>

                <input type="number" width="10" id="binSheetID" value="" />

                <button type="button" class="btn btn-default" onclick="addToSheet()">Add To Binsheet</button>

            </div>

            <button type="button" class="btn btn-default" onclick="copyParts()">Copy Selected Part IDs</button>

            <button type="button" class="btn btn-default" onclick="redirectToNewBinSheetWithSelected()">Put Selected Items Into New Bin Sheet</button>

         </div>

        <br />

        <%} %>

    </div>

    <br />

    <asp:Label ID="ItemCount" runat="server" Text=""></asp:Label>

    <asp:ListView ID="mainTable" runat="server" GroupPlaceholderID="groupPlaceHolder1" ItemPlaceholderID="itemPlaceHolder1" OnPagePropertiesChanging="OnPagePropertiesChanging">

        <LayoutTemplate>

            <table cellpadding="0" cellspacing="0" class="table table-striped">

                <tr>

                    <th>&nbsp;</th>

                    <th>&nbsp;</th>

                    <th style="vertical-align: bottom;">Part Number</th>

                    <th style="vertical-align: bottom;">Title</th>

                    <th style="vertical-align: bottom;">Status</th>

                    <th style="vertical-align: bottom; text-align: right;">Start Price</th>

                    <th style='vertical-align: bottom;' id="col1" runat="server">Created By</th>

                    <th style='vertical-align: bottom;' id="col2" runat="server">Tags</th>

                    <th style='vertical-align: bottom;'  id="col4" runat="server">BinLoc</th>

                    <th style='vertical-align: bottom; width: 200px;' id="col3" runat="server">Action</th>

                </tr>

                <asp:PlaceHolder runat="server" ID="groupPlaceHolder1"></asp:PlaceHolder>

                <tr>

                    <td colspan="9" valign="top">

                        <asp:DataPager ID="ResultPager" runat="server" PagedControlID="mainTable" PageSize="25">

                            <Fields>

                                <asp:NextPreviousPagerField ButtonType="Link" ShowFirstPageButton="true" ShowPreviousPageButton="true" ShowNextPageButton="false" />

                                <asp:NumericPagerField ButtonType="Link" />

                                <asp:NextPreviousPagerField ButtonType="Link" ShowNextPageButton="true" ShowLastPageButton="true" ShowPreviousPageButton = "false" />

                            </Fields>

                        </asp:DataPager>

                        <div style="float: right;">

                            <asp:Label ID="lblNumPages" runat="server" Text=""></asp:Label>

                        </div>

                    </td>

                </tr>

            </table>

        </LayoutTemplate>

        <GroupTemplate>

            <tr>

                <asp:PlaceHolder runat="server" ID="itemPlaceHolder1"></asp:PlaceHolder>

            </tr>

        </GroupTemplate>

        <ItemTemplate>

            <td id="select_<%# Eval("partNum") %>" <%#Eval("binsheet").ToString().Length > 0 && Eval("currentStatus").ToString().Contains("Post")? " style='background-color:green;'" : " style=''"%>>

                <input type="checkbox" class="select_partnumber" value="<%# Eval("partNum") %>">

            </td>

            <td>

                <%# Eval("currentStatus").ToString().IndexOf("Needs Imaging") >= 0 ? "" : "<a href='https://pictures.swedemom.com/pictures/" + Eval("picture1Location").ToString().Replace(@"Z:\", "").Replace("Z:/", "").Replace(@"z:\", "").Replace("z:/", "") + "' target='_blank'><img src='https://pictures.swedemom.com/pictures/" + Eval("picture1Location").ToString().Replace(@"Z:\", "").Replace("Z:/", "").Replace(@"z:\", "").Replace("z:/", "") + "' height=50 width=50 class='img-rounded' onerror='imgError(this);' /></a>"%>

            </td>

            <td><%# Eval("partNum") %></td>

            <td><%# Eval("shortDescription")%></td>

            <td><%# Eval("currentStatus")%></td>

            <td style="text-align: right;"><%# Eval("startPrice") != null && Eval("startPrice") != null ? "$" + Convert.ToDouble(Eval("startPrice")).ToString("F") : ""%></td>

            <% if (Session["bReadOnly"] != null && Session["bReadOnly"].ToString() == "True") { }

               else

               { %>

            <td><%# Eval("createdBy")%></td>

            <td><%# Eval("tag")%></td>

            <td><a href ='https://np.swedemom.com/hub/Account/invSearch.aspx?partnum=<%# Eval("partNum")%>'><%# Eval("BinLoc") %></a></td>

            <td>

                <%# Eval("currentStatus").ToString().IndexOf("Progress") >= 0 ? "<button onclick='window.location=\"createItem.aspx?itemID=" + Eval("itemID").ToString() + "\"' type=\"button\" class=\"btn btn-primary\" style='float: left; margin-left: 5px;'>Edit Item</button>" : "<button onclick='window.location=\"createItem.aspx?itemID=" + Eval("itemID").ToString() + "\"' type=\"button\" class=\"btn btn-primary\" style='float: left; margin-left: 5px;'>View Item</button>"%>

                <%# Eval("lastSaleID").ToString() != "" && (Session["bAdmin"].ToString().ToLower() == "yes" || Session["bAdmin"].ToString().ToLower() == "true" || Session["bAdmin"].ToString().ToLower() == "1") ? "<button onclick='window.location=\"CustomerService.aspx?saleID=" + Eval("lastSaleID").ToString() + "\"' type=\"button\" class=\"btn btn-primary\" style='float: left; margin-left: 5px;'>C/S</button>" : ""%>

            </td>

            <% } %>

        </ItemTemplate>

    </asp:ListView>

</asp:Content>

