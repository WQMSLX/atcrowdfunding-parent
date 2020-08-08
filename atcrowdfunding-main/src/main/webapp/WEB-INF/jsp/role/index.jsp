<%--
  Created by IntelliJ IDEA.
  User: zy
  Date: 2020/7/27
  Time: 10:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/common/css.jsp" %>
    <style>
        .tree li {
            list-style-type: none;
            cursor: pointer;
        }

        table tbody tr:nth-child(odd) {
            background: #F4F4F4;
        }

        table tbody td:nth-child(even) {
            color: #C00;
        }
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/common/menu.jsp"/>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" id="searchForm" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition"
                                       value="${param.condition}"
                                       placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="button" id="queryButton" class="btn btn-warning"><i
                                class="glyphicon glyphicon-search"></i> 查询
                        </button>
                    </form>
                    <button type="button" class="btn btn-danger" id="deleteBatchBtn"
                            style="float:right;margin-left:10px;"><i
                            class=" glyphicon glyphicon-remove"
                    ></i> 删除
                    </button>
                    <button type="button" class="btn btn-primary" style="float:right;"
                            id="saveBtn"><i class="glyphicon glyphicon-plus"
                                            data-toggle="modal" data-target="#addModal"></i> 新增
                    </button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr>
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox" id="threadCheckbox"></th>
                                <th>名称</th>

                                <th width="150">操作</th>
                            </tr>
                            </thead>
                            <tbody>


                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <ul class="pagination">

                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<!-- Modal -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="addModalLabel">新增</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="addForm">

                    <div class="form-group">
                        <label>角色名称</label>
                        <input type="text" class="form-control" name="name" placeholder="请输入用户名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" id="saveModalBtn" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>
<!-- updateModal -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="updateModalLabel">修改</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="updateForm">
                    <div class="form-group">
                        <label>角色名称</label>
                        <input type="hidden" name="id">
                        <input type="text" class="form-control" name="name" placeholder="请输入角色名称">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" id="updateModalBtn" class="btn btn-primary">修改</button>
            </div>
        </div>
    </div>
</div>
<%@include file="/WEB-INF/common/js.jsp" %>

<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function () {
            if ($(this).find("ul")) {
                $(this).toggleClass("tree-closed");
                if ($(this).hasClass("tree-closed")) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
        showData(1);
    });
    let json = {
        pageNum: 1,
        pageSize: 2,
        condition: "",

    }

    //1.先获得page数据
    function showData(pageNum) {
        json.pageNum = pageNum;
        $.ajax({
            type: "post",
            url: "${PATH}/role/loadData",
            data: json,
            success: function (result) {
                json.totalPages = result.pages;
                console.log(result.list);
                showTable(result.list);
                showNavg(result);
            }
        });
    }

    function showTable(list) {
        let content = "";
        $.each(list, function (i, e) {
            content += '<tr>';
            content += '<td>' + (i + 1) + '</td>';
            content += '<td><input type="checkbox" roleId="' + e.id + '" class="itemCheckboxClass"></td>';
            content += '<td>' + e.name + '</td>';
            content += '<td>';
            content += '     <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content += '     <button type="button" roleId="' + e.id + '" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content += '     <button type="button" roleId="' + e.id + '" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content += '</td>';
            content += '</tr>';
        });
        $("tbody").html(content);

    }

    /*    content+='<li class="disabled"><a href="#">上一页</a></li>'
        content+='<li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>'
        content+='<li><a href="#">2</a></li>'
        content+='<li><a href="#">3</a></li>'
        content+='<li><a href="#">4</a></li>'
        content+='<li><a href="#">5</a></li>'
        content+='<li><a href="#">下一页</a></li>'*/
    function showNavg(pageInfo) {
        let content = "";
        if (pageInfo.isFirstPage) {
            content += '<li class="disabled"><a href="#">上一页</a></li>'
        } else {
            content += '<li><a onclick="showData(' + (pageInfo.pageNum - 1) + ')">上一页</a></li>';
        }
        $.each(pageInfo.navigatepageNums, function (i, num) {
            content += '<li><a onclick="showData(' + num + ')">' + num + '</a></li>';
        })
        if (pageInfo.isLastPage) {
            content += '<li class="disabled"><a href="#">下一页</a></li>'
        } else {
            content += '<li><a onclick="showData(' + (pageInfo.pageNum + 1) + ')">下一页</a></li>';
        }
        $(".pagination").html(content);
    }

    $("#queryButton").click(function () {
        json.condition = $('#searchForm input[name="condition"]').val();
        showData(1);
    });
    /*-----------------add-----------------------*/
    $("#saveBtn").click(function () {
        $("#addModal").modal({
            show: true,
            backdrop: "static",
            keyboard: false
        });
    });
    $("#saveModalBtn").click(function () {
        //1.获取角色名(这里需要验证输入非法)
        let name = $("#addModal input[name='name']").val();
        //2.发起ajax请求
        $.ajax({
            type: "post",
            data: {name: name},/*必须和role中name参数同名*/
            url: "${PATH}/role/add",
            success: function (result) {
                //3.关闭模态框
                $("#addModal").modal("hide");
                if (result === "ok") {
                    layer.msg("保存成功！");
                    //4.刷新页面(到最后一页+1  如果没有就加一页)
                    showData(json.totalPages + 1);

                }else if(result==="403"){
                    layer.msg("您无权访问",{timeout:5000,icon:5});
                }
                else {
                    layer.msg("保存失败!");
                }
                //5.清空模态框
                name = $("#addModal input[name='name']").val("");
            }
        });

    });
    /*后来元素添加处理时不能用click处理*/
    $("tbody").on("click", ".updateBtnClass", function () {
        let id = $(this).attr("roleId");

        $.ajax({
            type: "post",
            data: {id: id},
            url: "${PATH}/role/getRoleById",
            success: function (result) {
                $("#updateModal input[name='name']").val(result.name);
                $("#updateModal input[name='id']").val(result.id);
                $("#updateModal").modal({
                    show: true,
                    backdrop: "static",
                    keyboard: false
                });
            }
        });
    });
    $("#updateModalBtn").click(function () {
        let id = $("#updateModal input[name='id']").val();
        let name = $("#updateModal input[name='name']").val();

        $.ajax({
            type: "post",
            url: "${PATH}/role/update",
            data: {
                id: id,
                name: name
            },
            success: function (result) {
                $("#updateModal").modal("hide");
                if (result === "ok") {
                    layer.msg("修改成功");
                    showData(json.pageNum);
                } else {
                    layer.msg("修改失败");
                }
                $("#updateModal input[name='id']").val("");
                $("#updateModal input[name='name']").val("");
            }
        });
    });
    /*===============================删除==================================*/
    $("tbody").on("click", ".deleteBtnClass", function () {
        let id = $(this).attr("roleId");//这里用prop没有用
        alert(id);
        layer.confirm("你确定要删除吗？", {btn: ['确定', '取消']},
            function () {
                $.ajax({
                    type: "post",
                    url: "${PATH}/role/delete",
                    data: {id: id},
                    success: function (result) {
                        if (result === "ok") {
                            layer.msg("删除成功");
                            showData(json.pageNum);
                        } else {
                            layer.msg("删除失败");
                        }
                    }
                });
            }, function () {
            });
    });
    /*=============================批量删除====================================*/
    //关联操作
    $("#threadCheckbox").click(function () {
        let theadCheck = $(this).prop("checked");
        $(".itemCheckboxClass").prop("checked", theadCheck);
    });
    //批量删除
    $("#deleteBatchBtn").click(function () {
        let checkedBoxList = $(".itemCheckboxClass:checked");
        if (checkedBoxList.length === 0) {
            layer.msg("请先选择要删除的角色！");
            return false;
        }
        let idArray = [];
        $.each(checkedBoxList, function (i, e) {//i索引  元素
            let roleId = $(e).attr("roleId");//将dom对象转换成
            idArray.push(roleId);
        });
        let iStr = idArray.join(",");
        layer.confirm("你确定要删除吗？", {btn: ['确定', '取消']}, function () {

            $.get("${PATH}/role/deleteBatch", {iStr: iStr}, function (result) {
                if (result === "ok") {
                    layer.msg("删除成功");
                    showData(json.pageNum);
                } else {
                    layer.msg("删除失败");
                }
            })
        }, function () {
            return false;
        });
    });
</script>
</body>
</html>

