<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>员工列表</title>
    <%
        pageContext.setAttribute("APP_PATH",request.getContextPath());
    %>
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">
    <script type="text/javascript" src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
</head>
<body>

<!-- 员工修改的模态框 -->
<div class="modal fade" id="empUpdateModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">员工修改</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <%--<input type="text" name="empName" class="form-control" id="empName_update_input" placeholder="empName">--%>
                            <%-- 名称不应该修改，只需要显示出来，所以input改为p --%>
                            <p class="form-control-static" id="empName_update_static"></p>
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_update_input" placeholder="email@myself.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_update_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_update_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%-- 提交部门id即可 --%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_update_btn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 员工添加的模态框 -->
<div class="modal fade" id="empAddModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">员工添加</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">empName</label>
                        <div class="col-sm-10">
                            <input type="text" name="empName" class="form-control" id="empName_add_input" placeholder="empName">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">email</label>
                        <div class="col-sm-10">
                            <input type="text" name="email" class="form-control" id="email_add_input" placeholder="email@myself.com">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">gender</label>
                        <div class="col-sm-10">
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender_add_input" value="M" checked="checked"> 男
                            </label>
                            <label class="radio-inline">
                                <input type="radio" name="gender" id="gender2_add_input" value="F"> 女
                            </label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-2 control-label">deptName</label>
                        <div class="col-sm-4">
                            <%-- 提交部门id即可 --%>
                            <select class="form-control" name="dId" id="dept_add_select">
                            </select>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="emp_save_btn">保存</button>
            </div>
        </div>
    </div>
</div>

<%-- 搭建显示页面 --%>
<div class="container">
    <%-- 标题 --%>
    <div class="row">
        <div class="col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <%-- 按钮 --%>
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="emp_add_modal_btn">新增</button>
            <button class="btn btn-danger" id="emp_delete_all_btn">删除</button>
        </div>
    </div>
    <%-- 表格数据 --%>
    <div class="row">
        <div class="col-md-12">
            <table class="table table-hover" id="emps_table">
                <thead>
                    <tr>
                        <th>
                            <input type="checkbox" id="check_all"/>
                        </th>
                        <th>#</th>
                        <th>empName</th>
                        <th>gender</th>
                        <th>email</th>
                        <th>deptName</th>
                        <th>操作</th>
                    </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <%-- 分页信息 --%>
    <div class="row">
        <%-- 分页文件信息 --%>
        <div class="col-md-6" id="page_info_area"></div>
        <%-- 分页条信息 --%>
        <div class="col-md-6" id="page_nav_area"></div>
    </div>
</div>

<script type="text/javascript">

    // 全局的总记录数，本页面
    var totalRecord,currentPage;

    // 页面加载完成后，发送一个ajax请求获取分页数据！而不是页面一开始就获取到数据！
    $(function () {
        // 去首页
        to_page(1);
    });

    function to_page(pn) {
        $.ajax({
            url:"${APP_PATH}/emps",
            data:"pn="+pn,
            type:"GET",
            success:function (result) {
                //console.log(result);
                // 1、解析并显示员工数据
                build_emps_table(result);
                // 2、解析并显示分页信息
                build_page_info(result);
                // 3、解析并显示分页条
                build_page_nav(result);
            }
        });
    }

    // 解析员工数据
    function build_emps_table(result) {
        // 构建之前，先清空
        $("#emps_table tbody").empty();

        var emps = result.extend.pageInfo.list;
        $.each(emps,function (index,item) {
            //alert(item.empName);
            var checkBoxTd = $("<td><input type='checkbox' class='check_item'/></td>");
            var empIdTd = $("<td></td>").append(item.empId);
            var empNameTd = $("<td></td>").append(item.empName);
            var genderTd = $("<td></td>").append(item.gender=='M'?"男":"女");
            var emailTd = $("<td></td>").append(item.email);
            var deptNameTd = $("<td></td>").append(item.department.deptName);

            var editBtn = $("<button></button>").addClass("btn btn-primary btn-sm edit_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-pencil"))
                .append("编辑");
            // 为每个编辑按钮添加一个自定义的属性，表示当前员工的id（在编辑更新时会用到！）
            editBtn.attr("edit-id",item.empId);
            var delBtn = $("<button></button>").addClass("btn btn-danger btn-sm delete_btn")
                .append($("<span></span>").addClass("glyphicon glyphicon-trash"))
                .append("删除");
            // 为删除按钮添加一个自定义的属性，表示当前删除员工的id
            delBtn.attr("del-id",item.empId);
            // 这两按钮放到同一个单元格中，两个按钮间再加个空格
            var btnTd = $("<td></td>").append(editBtn).append(" ").append(delBtn);

            // append方法执行完成后还是返回原来的元素tr，所以可以这样拼接
            $("<tr></tr>").append(checkBoxTd)
                .append(empIdTd)
                .append(empNameTd)
                .append(genderTd)
                .append(emailTd)
                .append(deptNameTd)
                .append(btnTd)
                .appendTo("#emps_table tbody");
        });
    }

    // 解析显示分页信息
    function build_page_info(result){
        $("#page_info_area").empty();
        $("#page_info_area").append("当前是第"+result.extend.pageInfo.pageNum+"页，共"+result.extend.pageInfo.pages+"页，总共"+result.extend.pageInfo.total+"条记录。");
        totalRecord = result.extend.pageInfo.total;
        currentPage = result.extend.pageInfo.pageNum;
    }

    // 解析分页条，点击分页能跳转到下一页
    function build_page_nav(result) {
        $("#page_nav_area").empty();

        var ul = $("<ul></ul>").addClass("pagination");
        // 首页
        var firstPageLi = $("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        // 前一页
        var prePageLi = $("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.pageInfo.hasPreviousPage == false){
            firstPageLi.addClass("disabled");
            prePageLi.addClass("hidden");
        } else {
            // 为元素添加点击翻页事件
            firstPageLi.click(function () {
                to_page(1);
            });
            prePageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum-1);
            });
        }
        // 下一页
        var nextPageLi = $("<li></li>").append($("<a></a>").append("&raquo;"));
        // 末页
        var lastPageLi = $("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        if(result.extend.pageInfo.hasNextPage == false){
            nextPageLi.addClass("hidden");
            lastPageLi.addClass("disabled");
        } else {
            nextPageLi.click(function () {
                to_page(result.extend.pageInfo.pageNum+1);
            });
            lastPageLi.click(function () {
                to_page(result.extend.pageInfo.pages);
            });
        }
        // 添加首页、前一页的提示
        ul.append(firstPageLi).append(prePageLi);
        // 遍历连续的分页
        $.each(result.extend.pageInfo.navigatepageNums,function (index,item) {
            var numLi = $("<li></li>").append($("<a></a>").append(item));
            if(result.extend.pageInfo.pageNum == item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_page(item);
            });
            // 遍历给ul中添加页码提示
            ul.append(numLi);
        });
        // 添加下一页、末页的提示
        ul.append(nextPageLi).append(lastPageLi);
        // 把ul添加到nav中
        var navEle = $("<nav></nav>").append(ul);
        navEle.appendTo("#page_nav_area");
    }

    // 完整重置表单信息：清空样式及内容
    function reset_form(ele){
        $(ele)[0].reset();
        $(ele).find("*").removeClass("has-error has-success");  // 清空样式
        $(ele).find(".help-block").text("");
    }

    // 点击新增按钮，弹出模态框
    $("#emp_add_modal_btn").click(function () {
        // 每次弹出之前都要清空表单数据（即：表单重置），否则可能会越过验证步骤
        //$("#empAddModal form")[0].reset();  // 仅仅是文本值被重置而已，应该让表单完整重置：数据、样式都要重置
        reset_form("#empAddModal form");
        // 发送ajax请求，查出部门信息，显示在下拉列表中
        getDepts("#empAddModal select");
        // 弹出模态框
        $("#empAddModal").modal({
            backdrop:"static"
        });
    });

    // 查询所有部门信息并显示在下拉列表中
    function getDepts(ele) {
        // 清空之前下拉列表的值
        $(ele).empty();
        $.ajax({
            url:"${APP_PATH}/depts",
            type:"GET",
            success:function (result) {
                //console.log(result);
                // 显示部门信息在下拉列表中
                $.each(result.extend.depts,function () {
                    var optionEle = $("<option></option>").append(this.deptName).attr("value",this.deptId);
                    optionEle.appendTo(ele);
                });
            }
        });
    }

    // 显示校验结果信息
    function show_validate_msg(ele,status,msg) {
        // 校验之前，要先清空这个元素原有的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text(msg);

        if ("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);
        } else if ("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }

    // 校验表单数据
    function validate_add_form(){
        // 使用正则表达式校验
        // 校验姓名
        var empName = $("#empName_add_input").val();
        var regName = /(^[a-zA-Z0-9_-]{6,16}$)|(^[\u2E80-\u9FFF]{2,5})/;
        //alert(regName.test(empName));
        if (!regName.test(empName)){
            //alert("用户名可以是2-5位中文或6-16位英文和数字的组合！");
            show_validate_msg("#empName_add_input","error","用户名可以是2-5位中文或6-16位英文和数字的组合！");
            return false;
        } else {
            show_validate_msg("#empName_add_input","success","");
        }
        // 校验邮箱
        var email = $("#email_add_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            //alert("邮箱格式不正确！");
            show_validate_msg("#email_add_input","error","邮箱格式不正确！");
            return false;
        } else {
            show_validate_msg("#email_add_input","success","");
        }
        return true;
    }

    // 校验用户名是否可用
    $("#empName_add_input").change(function () {
        // 发送ajax请求校验用户名是否可用（主要是重复问题）
        var  empName = this.value;
        $.ajax({
            url:"${APP_PATH}/checkuser",
            type:"POST",
            data:"empName="+empName,
            success:function (result) {
                if (result.code == 100){
                    show_validate_msg("#empName_add_input","success","用户名可用");
                    $("#emp_save_btn").attr("ajax-va","success");
                } else {
                    show_validate_msg("#empName_add_input","error",result.extend.va_msg);
                    $("#emp_save_btn").attr("ajax-va","error");
                }
            }
        });
    });

    // 点击保存员工
    $("#emp_save_btn").click(function () {
        // 模态框中填写的表单数据提交给服务器进行保存
        // 1、保存之前要先校验数据(这是前端校验)
        if (!validate_add_form()){
            return false;
        }
        // 2、判断之前的ajax用户名校验是否成功，成功才会继续往下执行
        if($(this).attr("ajax_va") == "error"){
            return false;
        }
        // 3、发送ajax请求，保存员工
        //alert($("#empAddModal form").serialize());  // 这就是向服务器发送的要保存的数据，都是从form中获取的值
        $.ajax({
            url:"${APP_PATH}/emp",
            type:"POST",
            data:$("#empAddModal form").serialize(),
            success:function (result) {
                //alert(result.msg);
                // 员工保存成功后，需要如下后续操作
                if (result.code == 100){  // 校验成功
                    // 1、关闭模态框
                    $("#empAddModal").modal('hide');
                    // 2、来到最后一页，显示刚才保存的数据
                    // 发送ajax请求，显示最后一页数据即可（可以传入总记录数【该数一般都会比最后一页页码大】作为最后一页页码，就算大于最后页码，分页插件会将其优化查到最后一页的）
                    to_page(totalRecord);
                } else {  // 校验失败
                    // 显示失败信息
                    // 有哪个字段的错误信息就显示哪个字段的（没错误的就是undefined）
                    //console.log(result);
                    //alert(result.extend.errorFields.email);
                    //alert(result.extend.errorFields.empName);
                    if (undefined != result.extend.errorFields.email){
                        // 显示邮箱错误信息
                        show_validate_msg("#email_add_input","error",result.extend.errorFields.email);
                    }
                    if (undefined != result.extend.errorFields.empName){
                        // 显示员工名错误信息
                        show_validate_msg("#empName_add_input","error",result.extend.errorFields.empName);
                    }
                }
            }
        });
    });

    /*
        以下是绑定不上按钮单击事件的，
        因为发送ajax请求后才创建出来，而以下是页面加载时绑定的操作，
        也就是说：按钮还没创建出来，你却给它绑定上？按钮都还没有呢！！！
            $(".edit_btn").click(function () {
                alert("edit");
            });
     */
    // 解决：
    // 1）创建按钮时绑定（耦合度高，不推荐）
    // 2）绑定点击.live()，即使是后来创建出来的元素，也可以绑定上
    /*
        $(".edit_btn").live(function () {  // 新新版jQuery中移除了live，使用on代替了
            alert("edit");
        });
     */
    $(document).on("click",".edit_btn",function () {
        //alert("edit");
        // 1、查询部门信息，并显示部门列表
        getDepts("#empUpdateModal select");
        // 2、查询员工信息，并显示员工信息
        getEmp($(this).attr("edit-id"));
        // 3、把员工的id传递给模态框的更新按钮，同时弹出模态框
        $("#emp_update_btn").attr("edit-id",$(this).attr("edit-id"));
        $("#empUpdateModal").modal({
            backdrop:"static"
        });
    });

    // 查询员工信息，并显示员工信息
    function getEmp(id) {
        $.ajax({
            url:"${APP_PATH}/emp/"+id,
            type:"GET",
            success:function (result) {
                //console.log(result);
                var empData = result.extend.emp;
                $("#empName_update_static").text(empData.empName);
                $("#email_update_input").val(empData.email);
                $("#empUpdateModal input[name=gender]").val([empData.gender]);
                $("#empUpdateModal select").val([empData.dId]);
            }
        });
    }

    // 点击更新按钮，更新员工信息
    $("#emp_update_btn").click(function () {
        // 1、验证邮箱是否合法
        var email = $("#email_update_input").val();
        var regEmail = /^([a-z0-9_\.-]+)@([\da-z\.-]+)\.([a-z\.]{2,6})$/;
        if (!regEmail.test(email)){
            show_validate_msg("#email_update_input","error","邮箱格式不正确！");
            return false;
        } else {
            show_validate_msg("#email_update_input","success","");
        }
        // 2、发送ajax请求保存更新的员工数据
        $.ajax({
            url:"${APP_PATH}/emp/"+$(this).attr("edit-id"),
            /*type:"POST",
            data:$("#empUpdateModal form").serialize()+"&_method=PUT",  /!* 别忘了这个参数：_method，rest风格的过滤器会帮你处理好的 *!/*/
            type:"PUT",  // ajax支持特殊请求
            data:$("#empUpdateModal form").serialize(),
            success:function (result) {
                //alert(result.msg);
                // 1、关闭对话框
                $("#empUpdateModal").modal("hide");
                // 2、回到本页面
                to_page(currentPage);
            }
        });
    });

    // 单个删除
    $(document).on("click",".delete_btn",function () {
        // 1、弹出是否确认删除对话框
        //alert($(this).parents("tr").find("td:eq(2)").text());
        var empName = $(this).parents("tr").find("td:eq(2)").text();
        var empId = $(this).attr("del-id");
        if(confirm("确认删除【"+ empName +"】吗？")){
            // 确认，发送ajax请求删除
            $.ajax({
                url:"${APP_PATH}/emp/"+empId,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    // 回到本页
                    to_page(currentPage);
                }
            });
        }
    });

    // 完成全选、全不选功能
    $("#check_all").click(function () {
        /*
            attr获取checked是undefined
                dom原生的属性；attr获取自定义属性的值
            prop修改、读取dom原生属性的值
                true、false
         */
        //alert($(this).attr("checked"));
        //alert($(this).prop("checked"));
        $(".check_item").prop("checked",$(this).prop("checked"));
    });

    // check_item
    // 因为是后来的元素，所以需要document
    $(document).on("click",".check_item",function () {
        // 判断当前选中的元素是否5个
        var flag = $(".check_item:checked").length == $(".check_item").length;
        $("#check_all").prop("checked",flag);
    });

    // 点击批量删除
    $("#emp_delete_all_btn").click(function () {
        var empNames = "";
        var del_idstr = "";
        $.each($(".check_item:checked"),function () {
            //alert($(this).parents("tr").find("td:eq(2)").text());
            empNames += $(this).parents("tr").find("td:eq(2)").text() + ",";
            // 组装员工id字符串
            del_idstr += $(this).parents("tr").find("td:eq(1)").text() + "-";
        });
        // 去除多余的逗号 ,
        empNames = empNames.substring(0,empNames.length-1);
        // 去除多余的id的横线 -
        del_idstr = del_idstr.substring(0,del_idstr.length-1);
        if (confirm("确认删除【"+ empNames +"】吗？")){
            // 发送ajax请求删除
            $.ajax({
                url:"${APP_PATH}/emp/"+del_idstr,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    // 回到当前页面
                    to_page(currentPage);
                }
            });
        }
    });

</script>

</body>
</html>
