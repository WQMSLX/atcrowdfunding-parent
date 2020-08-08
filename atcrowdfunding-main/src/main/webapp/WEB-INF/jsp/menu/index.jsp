<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

            <div class="panel panel-default">
                <div class="panel-heading"><i class="glyphicon glyphicon-th-list"></i> 权限菜单列表
                    <div
                            style="float:right;cursor:pointer;" data-toggle="modal" data-target="#myModal"><i class="glyphicon
        glyphicon-question-sign"></i></div>
                </div>
                <div class="panel-body">
                    <ul id="treeDemo" class="ztree"></ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- addModal -->
<div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="addModalLabel">新增</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="addForm">
                    <input type="hidden" name="pid"/>
                    <div class="form-group">
                        <label>菜单名称</label>
                        <input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
                    </div>
                    <div class="form-group">
                        <label>选择图标</label><%--用选择器更好--%>
                        <%--      <select type="" class="form-control" name="name" >
                                  <option value=""
                              </select>--%>
                        <input type="text" class="form-control" name="icon" placeholder="请选择图标">
                    </div>
                    <div class="form-group">
                        <label>URL地址</label>
                        <input type="text" class="form-control" name="url" placeholder="地址">
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
<%--updateModal--%>
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span
                        aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title" id="updateModalLabel">新增</h4>
            </div>
            <div class="modal-body">
                <form role="form" id="updateForm">
                    <input type="hidden" name="id"/>
                    <input type="hidden" name="pid"/>
                    <div class="form-group">
                        <label>菜单名称</label>
                        <input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
                    </div>
                    <div class="form-group">
                        <label>选择图标</label><%--用选择器更好--%>
                        <%--      <select type="" class="form-control" name="name" >
                                  <option value=""
                              </select>--%>
                        <input type="text" class="form-control" name="icon" placeholder="请选择图标">
                    </div>
                    <div class="form-group">
                        <label>URL地址</label>
                        <input type="text" class="form-control" name="url" placeholder="地址">
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
        showTree();
    });


    function showTree() {

        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: "pid",
                }
            },
            view: {
                addDiyDom: customeIcon,
                addHoverDom: customeAddBtn,
                removeHoverDom: customeRemoveBtn
            }
        };

        var zNodes = {};
        $.get("${PATH}/menu/loadTree", {}, function (result) {
            zNodes = result;
            //增加根节点
            zNodes.push({"id": 0, "name": "系统权限菜单", "icon": "glyphicon glyphicon-th-list", "children": []});
            $.fn.zTree.init($("#treeDemo"), setting, zNodes);
            let treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);
        });

    }

    function customeIcon(treeId, treeNode) {//treeNode就是TMenu对象
        $("#" + treeNode.tId + "_ico").removeClass();//.addClass();
        $("#" + treeNode.tId + "_span").before("<span class='" + treeNode.icon + "'></span>")

    }


    // 鼠标移动到节点上显示按钮组
    function customeAddBtn(treeId, treeNode) {
        var aObj = $("#" + treeNode.tId + "_a");
        aObj.attr("href", "javascript:;"); //禁用链接
        aObj.attr("onclick", "return false;"); //禁用单击事件

        if (treeNode.editNameFlag || $("#btnGroup" + treeNode.tId).length > 0) {
            return;
        }

        let s = '<span id="btnGroup' + treeNode.tId + '">';
        if (treeNode.level === 0) { //根节点
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="addBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if (treeNode.level === 1) { //分支节点
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="updateBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            if (treeNode.children.length === 0) {
                s +=
                    '<a class="btn btn-info dropdown-toggle btn-xs" onclick="deleteBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
            }
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="addBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
        } else if (treeNode.level === 2) { //叶子节点
            s += '<a class="btn btn-info dropdown-toggle btn-xs"  onclick="updateBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;"  href="#" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
            s +=
                '<a class="btn btn-info dropdown-toggle btn-xs" onclick="deleteBtn(' + treeNode.id + ')" style="margin-left:10px;padding-top:0px;" href="#">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
        }
        s += '</span>';
        aObj.after(s);
    }

    function customeRemoveBtn(treeId, treeNode) {
        $("#btnGroup" + treeNode.tId).remove();
    }

    function addBtn(id) {
        $("#addModal input[name='pid']").val(id);
        $("#addModal").modal({
            show: true,
            backdrop: "static",
            keyboard: false
        });
    }

    /*------------------------------add----------------------------------------*/
    $("#saveModalBtn").click(function () {

        let pid = $("#addModal input[name='pid']").val();
        let name = $("#addModal input[name='name']").val();
        let icon = $("#addModal input[name='icon']").val();
        let url = $("#addModal input[name='url']").val();
        $.ajax({
            type: 'post',
            url: '${PATH}/menu/addMenu',
            data: {pid: pid, name: name, icon: icon, url: url},
            success: function (result) {
                if (result === "ok") {
                    layer.msg("添加成功");
                    showTree();
                } else {
                    layer.msg("添加失败");
                }
            }
        });
        $("#addModal").modal("hide");
        $("#updateModal input[name='pid']").val();
        $("#updateModal input[name='name']").val();
        $("#updateModal input[name='icon']").val();
        $("#updateModal input[name='url']").val();
    });

    /*----------------------------update------------------------------------------------*/
    function updateBtn(id) {
        $.get("${PATH}/menu/get", {id: id}, function (result) {
            let id = $("#updateModal input[name='id']").val(result.id);
            let pid = $("#updateModal input[name='pid']").val(result.pid);
            let name = $("#updateModal input[name='name']").val(result.name);
            let icon = $("#updateModal input[name='icon']").val(result.icon);
            let url = $("#updateModal input[name='url']").val(result.url);

            $("#updateModal").modal({

                show: true,
                backdrop: "static",
                keyboard: false
            });
        });

    }

    $("#updateModalBtn").click(function () {
        let id = $("#updateModal input[name='id']").val();
        let pid = $("#updateModal input[name='pid']").val();
        let name = $("#updateModal input[name='name']").val();
        let icon = $("#updateModal input[name='icon']").val();
        let url = $("#updateModal input[name='url']").val();
        $.ajax({
            type: "post",
            url: "${PATH}/menu/update",
            data: {id: id, pid: pid, name: name, icon: icon, url: url},
            success: function (result) {
                if (result === "ok") {
                    layer.msg("修改成功");
                    showTree();
                } else {
                    layer.msg("修改失败");
                }
                $("#updateModal").modal("hide");
                $("#updateModal input[name='id']").val();
                $("#updateModal input[name='pid']").val();
                $("#updateModal input[name='name']").val();
                $("#updateModal input[name='icon']").val();
                $("#updateModal input[name='url']").val();
            }
        });
    });

    /*--------------------------------deleteBtn-----------------------------------------------------*/
    function deleteBtn(id) {
        layer.confirm("你确定要删除吗？",{btn:['确定','取消']},function () {
            $.get("${PATH}/menu/delete",{id:id},function (result) {
                if(result==="ok"){
                    layer.msg("删除成功");
                    showTree();
                }else{
                    layer.msg("删除失败");
                }
            })
        },function () {
        });
    }
</script>
</body>
</html>
