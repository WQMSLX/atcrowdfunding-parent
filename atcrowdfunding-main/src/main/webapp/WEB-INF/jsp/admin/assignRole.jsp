<%--
  Created by IntelliJ IDEA.
  User: WangQiming
  Date: 2020/7/30
  Time: 21:59
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
>
<!DOCTYPE html>
<html lang="zh-CN">
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
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/common/top.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/common/menu.jsp"/>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label for="exampleInputPassword1">未分配角色列表</label><br>
                            <select id="leftRoleList" class="form-control" multiple size="20"
                                    style="width:300px;overflow-y:auto;">
                                <c:forEach items="${unAssignList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li id="leftToRightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                <br>
                                <li id="rightToLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left"
                                    style="margin-top:20px;"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label for="exampleInputPassword1">已分配角色列表</label><br>
                            <select id="rightRoleList" class="form-control" multiple size="20"
                                    style="width:300px;overflow-y:auto;">
                                <c:forEach items="${assignList}" var="role">
                                    <option value="${role.id}">${role.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                <h4 class="modal-title" id="myModalLabel">帮助</h4>
            </div>
            <div class="modal-body">
                <div class="bs-callout bs-callout-info">
                    <h4>测试标题1</h4>
                    <p>测试内容1，测试内容1，测试内容1，测试内容1，测试内容1，测试内容1</p>
                </div>
                <div class="bs-callout bs-callout-info">
                    <h4>测试标题2</h4>
                    <p>测试内容2，测试内容2，测试内容2，测试内容2，测试内容2，测试内容2</p>
                </div>
            </div>
            <!--
            <div class="modal-footer">
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              <button type="button" class="btn btn-primary">Save changes</button>
            </div>
            -->
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
    });
    //分配角色
    $("#leftToRightBtn").click(function () {
        let leftOptionSelected = $("#leftRoleList option:selected");

        if (leftOptionSelected.length === 0) {
            layer.msg("请先选择分配角色");
            return false;
        }

        let idStr = "" +${adminId}; //   adminId=${param.id} &roleId=1 &roleId=2 &roleId=3

        $.each(leftOptionSelected, function (i, e) { // e ==>>>  <option value="${role.id}">${role.name}</option>
            let roleId = e.value;
            idStr += ",";
            idStr += roleId;
        });

        $.ajax({
            type: "post",
            url: "${PATH}/admin/doAssignRoleToAdmin",
            data: idStr,
            contentType: "application/json",/*字符串必须加；否则只能是json*/
            success: function (result) {
                if ("ok" === result) {
                    $("#rightRoleList").append(leftOptionSelected.clone());
                    leftOptionSelected.remove();
                    layer.msg("分配成功");
                } else {
                    layer.msg("分配失败");
                }
            }
        });
    });


    //取消分配角色
    $("#rightToLeftBtn").click(function () {
        var rightOptionSelected = $("#rightRoleList option:selected");

        if (rightOptionSelected.length === 0) {
            layer.msg("请先选择要取消分配的角色");
            return false;
        }

        let str = "${adminId}"; //   adminId=${param.id} &roleId=1 &roleId=2 &roleId=3
        $.each(rightOptionSelected, function (i, e) { // e ==>>>  <option value="${role.id}">${role.name}</option>
            let roleId = e.value;

            str += ",";
            str += roleId;
        });
        alert(str);
        $.ajax({
            type: "post",
            url: "${PATH}/admin/doUnAssignRoleToAdmin",
            data: str,
            contentType: "application/json",/*字符串必须加；否则只能是json*/
            success: function (result) {
                if ("ok" === result) {
                    $("#leftRoleList").append(rightOptionSelected.clone());
                    rightOptionSelected.remove();
                    layer.msg("取消分配成功");
                } else {
                    layer.msg("取消分配失败");
                }
            }
        });
    });
</script>
</body>
</html>

